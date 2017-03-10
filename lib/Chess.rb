class Chess
  class Board
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
