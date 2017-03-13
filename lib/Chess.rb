class Chess
  class Board
    attr_accessor :grid
    class Square
      attr_accessor :row, :column, :piece,
        :above, :below, :left, :right, :top_left, :top_right, :bottom_left, :bottom_right

      def initialize(column='A', row='0')
        @row = row
        @column = column
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
      ('A'..'H').each do |char|
        @grid[char] = Hash.new
        ('1'..'8').each do |num|
          @grid[char][num] = Square.new(char, num)
        end
      end
      self.connect_squares
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
      square.link(@grid[col][(row.ord+1).chr],:above) if square.above.nil? and row != '8'
      square.link(@grid[col][(row.ord-1).chr],:below) if square.below.nil? and row != '1'
      square.link(@grid[(col.ord-1).chr][row],:left) if square.left.nil? and col != 'A'
      square.link(@grid[(col.ord+1).chr][row],:right) if square.right.nil? and col != 'H'
      square.link(@grid[(col.ord-1).chr][(row.ord-1).chr],:bottom_left) if square.bottom_left.nil? and row != '1' and col != 'A'
      square.link(@grid[(col.ord+1).chr][(row.ord-1).chr],:top_left) if square.top_left.nil? and row != '1' and col != 'H'
      square.link(@grid[(col.ord-1).chr][(row.ord+1).chr],:bottom_right) if square.bottom_right.nil? and row != '8' and col != 'A'
      square.link(@grid[(col.ord+1).chr][(row.ord+1).chr],:top_right) if square.top_right.nil? and row != '8' and col != 'H'
    end

  end

end




##Decide what a legal move is
##Decide if a king is in check
##Decide if a king is in checkmate
##Decide if there are no more legal moves

##Get a list of legal moves
###Moves should include castling (Signified by 0-0 or 0-0-0)
###Pawns move foward one space and depend on their color
###Knights always have the same movement and only need to check for out of bounce
###Rooks, Queens, and Bishops stop their movement once they hit something.
###King just moves one square.

##Modify that list by removing all put the king in checkmate
##If moves exist, the game is drawn if the king is not in check
##The game is won if the king is in check.
