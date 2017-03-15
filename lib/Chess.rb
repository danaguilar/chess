require 'colorize'
require_relative 'Pieces.rb'
class Chess
include Pieces
  attr_accessor :board
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

    Knight.new(false,@board.grid['4']['E'])
    Knight.new(true,@board.grid['2']['F'])
    Pawn.new(false,@board.grid['6']['D'])
    Pawn.new(true,@board.grid['2']['A'])


  end

  def add_new_piece(square,piece)
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
    return pieces.keep_if{|piece| piece.is_white} if color == :white
    return pieces.keep_if{|piece| piece.is_black} if color == :black
    return []
  end

  def draw_board
    #system "clear" or system "cls"
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



chess = Chess.new
chess.hightlight_squares(chess.board.grid['4']['E'].piece.legal_moves)
chess.draw_board
puts chess.get_all_pieces.inspect
#puts chess.board.grid['4']['E'].piece.can_capture.inspect
