module Pieces
class Piece
  attr_accessor :current_square
  def initialize(white = true, square = nil)
    @white = white
    @current_square = square
    square.piece = self
  end
  def is_white?
    return @white
  end

  def is_black?
    return !@white
  end

  def to_square(square)
    @current_square.piece = nil unless @current_square.nil?
    @current_square = square
    square.piece = self
  end
end

class Pawn < Piece
  attr_accessor :has_moved
  attr_reader :image
  def initialize(white = true, square = nil)
      super
      @image = '♙'.colorize(:black) if is_white?
      @imagae = '♟'.colorize(:black) if is_black?
      has_moved = false
  end


  def white_legal_moves()
    legal_moves = []
    ##Check regular movement
    unless @current_square.above.nil?
      check_square = @current_square.above
      legal_moves << check_square.to_move if check_square.piece.nil?
      ##Check if pawn hasn't moved
      unless has_moved
        check_square = check_square.above
        legal_moves << check_square.to_move if check_square.piece.nil?
      end
    end

    ##Check if pawn can take anything
    legal_moves << @current_square.top_left unless @current_square.top_left.nil? or @current_square.top_left.piece.nil?
    legal_moves << @current_square.top_right unless @current_square.top_right.nil? or @current_square.top_right.piece.nil?
    return legal_moves
  end
end
end
