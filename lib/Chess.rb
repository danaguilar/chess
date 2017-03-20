require 'colorize'
require_relative 'Pieces.rb'

##IDEAS
#Captured pieces off to the side for each side
#Maybe speed chess?
class Chess
include Pieces
  attr_accessor :board, :check_board, :white_captured, :black_captured, :white_king, :black_king
  class Board
    attr_accessor :grid
    class Square
      attr_accessor :row, :column, :piece,
        :above, :below, :left, :right, :top_left, :top_right, :bottom_left, :bottom_right,
        :is_hightlighted

      def initialize(column='A', row='0')
        @row = row
        @column = column
        @is_hightlighted = false
      end

      def inspect
        return "row: #{@row}, column: #{@column}, piece: #{@piece}"
      end

      def to_move
        return "#{@column}#{@row}"
      end

      def to_s
        if @piece.nil?
          return ' '
        else
          return @piece.image
        end
      end

      def link(square,direction)
        case direction
        when :above
          self.above = square
          square.below = self
        when :below
          self.below = square
          square.above = self
        when :right
          self.right = square
          square.left = self
        when :left
          self.left = square
          square.right = self
        when :top_left
          self.top_left = square
          square.bottom_right = self
        when :top_right
          self.top_right = square
          square.bottom_left = self
        when :bottom_right
          self.bottom_right = square
          square.top_left = self
        when :bottom_left
          self.bottom_left = square
          square.top_right = self
        else
          return false
        end
        return true
      end
    end
    def initialize
      @grid = Hash.new
      ('1'..'8').each do |num|
        @grid[num] = Hash.new
        ('A'..'H').each do |char|
          @grid[num][char] = Square.new(char, num)
        end
      end
      connect_squares
    end
    def connect_squares
      @grid.each do |col_name, row|
        row.each do |row_name, square|
          link_neighbors(square)
        end
      end
    end
    def link_neighbors(square)
      row = square.row
      col = square.column
      square.link(@grid[(row.ord+1).chr][col],:above) if square.above.nil? and row != '8'
      square.link(@grid[(row.ord-1).chr][col],:below) if square.below.nil? and row != '1'
      square.link(@grid[row][(col.ord-1).chr],:left) if square.left.nil? and col != 'A'
      square.link(@grid[row][(col.ord+1).chr],:right) if square.right.nil? and col != 'H'
      square.link(@grid[(row.ord-1).chr][(col.ord-1).chr],:bottom_left) if square.bottom_left.nil? and row != '1' and col != 'A'
      square.link(@grid[(row.ord+1).chr][(col.ord-1).chr],:top_left) if square.top_left.nil? and row != '8' and col != 'A'
      square.link(@grid[(row.ord-1).chr][(col.ord+1).chr],:bottom_right) if square.bottom_right.nil? and row != '1' and col != 'H'
      square.link(@grid[(row.ord+1).chr][(col.ord+1).chr],:top_right) if square.top_right.nil? and row != '8' and col != 'H'
    end
  end

  def initialize(white = :light_white, black = :green)
    @board = Board.new
    @check_board = Board.new
    @white_color = white
    @black_color = black
    @white_captured = Array.new
    @black_captured = Array.new
    setup_board
    self.copy_board
  end

  def setup_board
    setup_white
    setup_black
  end
  def setup_white
    ('A'..'H').each do |char|
      Pawn.new(true,@board.grid['2'][char])
    end
    Rook.new(true,@board.grid['1']['A'])
    Rook.new(true,@board.grid['1']['H'])
    Knight.new(true,@board.grid['1']['B'])
    Knight.new(true,@board.grid['1']['G'])
    Bishop.new(true,@board.grid['1']['C'])
    Bishop.new(true,@board.grid['1']['F'])
    @white_king = King.new(true,@board.grid['1']['E'])
    Queen.new(true,@board.grid['1']['D'])
  end
  def setup_black
    ('A'..'H').each do |char|
      Pawn.new(false,@board.grid['7'][char])
    end
    Rook.new(false,@board.grid['8']['A'])
    Rook.new(false,@board.grid['8']['H'])
    Knight.new(false,@board.grid['8']['B'])
    Knight.new(false,@board.grid['8']['G'])
    Bishop.new(false,@board.grid['8']['C'])
    Bishop.new(false,@board.grid['8']['F'])
    @black_king = King.new(false,@board.grid['8']['E'])
    Queen.new(false,@board.grid['8']['D'])
  end

  def make_new_move(start_square, end_square, color)
    return :bad_format unless start_square.size == 2 and end_square.size == 2
    return :start_out_of_bounds unless start_square[0].between?('A','H') and start_square[1].between?('1','8')
    return :end_out_of_bounds unless end_square[0].between?('A','H') and end_square[1].between?('1','8')
    starting_square = @board.grid[start_square[1]][start_square[0]]
    landing_square = @board.grid[end_square[1]][end_square[0]]
    move_array = [starting_square, landing_square]
    unless get_all_moves(color).include? move_array
      return :no_piece_found
    end
    if starting_square.piece.can_capture.include? landing_square
      capture(starting_square.piece, landing_square)
    else
      starting_square.piece.to_square(landing_square)
    end
    return :success
  end


  def in_check?(color)
    if color == :white
      pieces = get_all_pieces(:black)
      can_capture = Array.new
      pieces.each do |piece|
        squares_to_capture = piece.can_capture
        pieces_to_capture = squares_to_capture.collect {|square| square.piece}
        can_capture.concat(pieces_to_capture)
      end
      return true if can_capture.include?(@white_king)
      return false
    elsif color == :black
      pieces = get_all_pieces(:white)
      can_capture = Array.new
      pieces.each do |piece|
        squares_to_capture = piece.can_capture
        pieces_to_capture = squares_to_capture.collect {|square| square.piece}
        can_capture.concat(pieces_to_capture)
      end
      return true if can_capture.include?(@black_king)
      return false
    end
  end

  def check_all_moves(color)
    legal_moves = Array.new
    move_list = get_all_moves(color)
      move_list.each do |move|
        copy_board
        make_test_move(move[0],move[1])
          legal_moves << move unless is_test_check?(color)
      end
  end

  def make_test_move(starting_square, ending_square)
    test_start = [starting_square.column,starting_square.row]
    test_end = [ending_square.column, ending_square.row]
  end

  def get_all_moves(color = :all)
    move_list = Array.new
    get_all_pieces(color).each do |piece|
      piece.legal_moves.each   do |ending_square|
        move_list << Array.new([piece.current_square,ending_square])
      end
    end
    return move_list
  end

  def capture(piece,square)
    captured_piece = square.piece
    captured_piece.is_white? ? @black_captured << captured_piece : @white_captured << captured_piece
    captured_piece.current_square = nil
    square.piece = nil
    piece.to_square(square)
  end


  def get_all_pieces(color = :all)
    pieces = Array.new
    @board.grid.each do |col_name, row|
      row.each do |row_name, square|
        pieces << square.piece unless square.piece.nil?
      end
    end
    return pieces if color == :all
    return pieces.keep_if{|piece| piece.is_white?} if color == :white
    return pieces.keep_if{|piece| piece.is_black?} if color == :black
    return []
  end

  def copy_board
    @board.grid.each do |col_name, row|
      row.each do |row_name, square|
        @check_board.grid[col_name][row_name].piece = square.piece
      end
    end
  end

  def draw_board
    count = 0
    print "   "
    ('A'..'H').each do |char|
      print "  #{char}   "
    end
    puts ''
    @board.grid.reverse_each do |col_name, row|
        draw_row(row, count, col_name)
      count += 1
    end
  end

def hightlight_squares(squares)
  return nil if squares.nil?
  squares.each do |square|
    square.is_hightlighted = true
  end
end

def highlight_color(square,default)
  if square.is_hightlighted
    if square.piece.nil?
      return :light_blue
    else
      return :red
    end
  else
    return default
  end
end
def draw_row(row, count, col_name)
  3.times do |num|
    if count%2 == 0
      color_count = 0
    else
      color_count = 1
    end
    if num == 1
      row.each do |row_name,square|
        print " #{col_name} " if row_name == 'A'
        if color_count % 2 == 0
          print (' '*2 + square.to_s + ' '*3).colorize(:background => highlight_color(square, @white_color))
        else
          print (' '*2 + square.to_s + ' '*3).colorize(:background => highlight_color(square, @black_color))
        end
        color_count += 1
      end
    else
      row.each do |row_name,square|
        print "   " if row_name == 'A'
        if color_count % 2 == 0
          print (' '*6).colorize(:background => highlight_color(square,@white_color))
        else
          print (' '*6).colorize(:background => highlight_color(square,@black_color))
        end
        color_count += 1
      end
    end
    print "\n"
  end
end

end


=begin
chess = Chess.new
chess.make_move('E2','E4')
chess.make_move('D7','D5')
chess.make_move('E4','D5')
chess.draw_board
puts "White captured: #{chess.white_captured.map{|piece| piece.image}.join('-')}"
puts "Black captured: #{chess.black_captured.map{|piece| piece.image}.join('-')}"


puts chess.get_all_pieces.map!{|piece| piece.image}.join('-')
puts chess.get_all_pieces(:white).map!{|piece| piece.image}.join('-')
puts chess.get_all_pieces(:black).map!{|piece| piece.image}.join('-')
chess.get_all_pieces(:white).each do |piece|
  if piece.legal_moves.length > 0
    puts "#{piece.image}"
    piece.legal_moves.each do |square|
      puts "\t#{square.to_move}"
    end
  end
end
=end

#puts chess.board.grid['4']['E'].piece.can_capture.inspect
