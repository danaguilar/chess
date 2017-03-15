require 'colorize'
require_relative 'Pieces.rb'

##IDEAS
#Captured pieces off to the side for each side
#Maybe speed chess?
class Chess
include Pieces
  attr_accessor :board, :white_captured, :black_captured
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
    @white_color = white
    @black_color = black
    @white_captured = Array.new
    @black_captured = Array.new
    setup_board
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
    King.new(true,@board.grid['1']['E'])
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
    King.new(false,@board.grid['8']['E'])
    Queen.new(false,@board.grid['8']['D'])
  end

  #Should be in the form [col][row] for both. EG: E4, A1
  def make_move(start_square, end_square, color)
    return :bad_format unless start_square.size == 2 and end_square.size == 2
    return :start_out_of_bounds unless start_square[0].between?('A','H') and start_square[1].between?('1','8')
    return :end_out_of_bounds unless end_square[0].between?('A','H') and end_square[1].between?('1','8')
    return :no_piece_found if @board.grid[start_square[1]][start_square[0]].piece.nil?
    return :not_a_color unless color == :white or color == :black
    moving_piece = @board.grid[start_square[1]][start_square[0]].piece
    landing_square = @board.grid[end_square[1]][end_square[0]]
    return :cannot_move_white_piece if moving_piece.is_white? and color != :white
    return :cannot_move_black_piece if moving_piece.is_black? and color != :black
    return :invalid_move unless moving_piece.legal_moves.include? landing_square
    if moving_piece.can_capture.include? landing_square
      capture(moving_piece, landing_square)
    else
      moving_piece.to_square(landing_square)
    end
    return :success
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

  def draw_board
    count = 0
    @board.grid.reverse_each do |col_name, row|
        draw_row(row, count)
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
def draw_row(row, count)
  3.times do |num|
    if count%2 == 0
      color_count = 0
    else
      color_count = 1
    end
    if num == 1
      row.each do |row_name,square|
        if color_count % 2 == 0
          print (' '*2 + square.to_s + ' '*3).colorize(:background => highlight_color(square, @white_color))
        else
          print (' '*2 + square.to_s + ' '*3).colorize(:background => highlight_color(square, @black_color))
        end
        color_count += 1
      end
    else
      row.each do |row_name,square|
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
