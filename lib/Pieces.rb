module Pieces
class Piece
  attr_accessor :current_square, :has_moved
  @@BlackColor = :black
  @@WhiteColor = :blue
  def initialize(white = true, square = nil)
    @white = white
    @current_square = square
    square.piece = self
    @has_moved = false
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
    @has_moved = true
  end

  def opponent_exists(square)
    return false if square.nil? or square.piece.nil?
    return true if self.is_white? != square.piece.is_white?
    return false
  end

  def friend_exists(square)
    return false if square.nil? or square.piece.nil?
    return false if self.is_white? != square.piece.is_white?
    return true
  end

  #returns the square relative to current square given the row and col movement
  def relative_square(row,col)
    index_square = @current_square
    if row > 0
      row.times do
        return nil if index_square.right.nil?
        index_square = index_square.right
      end
    end

    if row < 0
      (row*-1).times do
        return nil if index_square.left.nil?
        index_square = index_square.left
      end
    end

    if col > 0
      col.times do
        return nil if index_square.above.nil?
        index_square = index_square.above
      end
    end

    if col < 0
      (col*-1).times do
        return nil if index_square.below.nil?
        index_square = index_square.below
      end
    end
    return index_square
  end
end
class Pawn < Piece
  attr_reader :image
  def initialize(white = true, square = nil)
      super
      @image = '♟'.colorize(@@WhiteColor) if is_white?
      @image = '♟'.colorize(@@BlackColor) if is_black?
  end

  #Returns all the pieces that the current pawn can capture in a given turn
  def can_capture
    legal_move_list = self.legal_moves
    return legal_move_list.keep_if {|square| !square.piece}
  end

  #Returns an array of squares that are legal moves for the piece this turn
  def legal_moves
    if self.is_white?
      legal_moves = []
      ##Check regular movement
      unless @current_square.above.nil?
        check_square = @current_square.above
        legal_moves << check_square if check_square.piece.nil?
        ##Check if pawn hasn't moved
        unless has_moved
          check_square = check_square.above
          legal_moves << check_square if check_square.piece.nil?
        end
      end
      ##Check if pawn can take anything
      legal_moves << @current_square.top_left if opponent_exists(@current_square.top_left)
      legal_moves << @current_square.top_right if opponent_exists(@current_square.top_right)
      return legal_moves
    else
      legal_moves = []
      ##Check regular movement
      unless @current_square.below.nil?
        check_square = @current_square.below
        legal_moves << check_square if check_square.piece.nil?
        ##Check if pawn hasn't moved
        unless has_moved
          check_square = check_square.below
          legal_moves << check_square if check_square.piece.nil?
        end
      end
      ##Check if pawn can take anything
      legal_moves << @current_square.bottom_left if opponent_exists(@current_square.bottom_left)
      legal_moves << @current_square.bottom_right if opponent_exists(@current_square.bottom_right)
      return legal_moves
    end
  end
end
class Knight < Piece
  @@MoveList = [[-2,-1],[-2,1],[2,-1],[2,1],[-1,2],[-1,-2],[1,2],[1,-2]]
  attr_accessor :has_moved
  attr_reader :image
  def initialize(white = true, square = nil)
      super
      @image = '♞'.colorize(@@WhiteColor) if is_white?
      @image = '♞'.colorize(@@BlackColor) if is_black?
  end

  #Returns all the pieces that the current pawn can capture in a given turn
  def can_capture
    legal_move_list = self.legal_moves
    return legal_move_list.keep_if {|square| !square.piece}
  end

  #Returns an array of squares that are legal moves for the piece this turn
  def legal_moves
    legal_move_list = []
    @@MoveList.each do |move_set|
      moved_square = relative_square(move_set[0],move_set[1])
      legal_move_list << moved_square unless moved_square.nil? or friend_exists(moved_square)
    end
    return legal_move_list
  end
end

end
