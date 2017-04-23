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

  def to_square(square,true_move = true)
    @current_square.piece = nil unless @current_square.nil?
    @current_square = square
    square.piece = self
    @has_moved = true if true_move
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

  #Returns all the pieces that the current pawn can capture in a given turn
  def can_capture
    legal_move_list = self.legal_moves
    return legal_move_list.keep_if {|square| !square.piece.nil?}
  end

end
class Pawn < Piece
  attr_reader :image
  def initialize(white = true, square = nil)
      super
      @image = '♟'.colorize(@@WhiteColor) if is_white?
      @image = '♟'.colorize(@@BlackColor) if is_black?
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
class Bishop < Piece
  attr_reader :image
  def initialize(white = true, square = nil)
      super
      @image = '♝'.colorize(@@WhiteColor) if is_white?
      @image = '♝'.colorize(@@BlackColor) if is_black?
  end

  def legal_moves
    legal_move_list = []
    ##Top left diagonal
    index_square = @current_square
    until index_square.top_left.nil? or !index_square.top_left.piece.nil? do
      index_square = index_square.top_left
      legal_move_list << index_square
    end
    legal_move_list << index_square.top_left if opponent_exists(index_square.top_left)

    ##Top right diagonal
    index_square = @current_square
    until index_square.top_right.nil? or !index_square.top_right.piece.nil? do
      index_square = index_square.top_right
      legal_move_list << index_square
    end
    legal_move_list << index_square.top_right if opponent_exists(index_square.top_right)

    ##Bottom left diagonal
    index_square = @current_square
    until index_square.bottom_left.nil? or !index_square.bottom_left.piece.nil? do
      index_square = index_square.bottom_left
      legal_move_list << index_square
    end
    legal_move_list << index_square.bottom_left if opponent_exists(index_square.bottom_left)

    ##Bottom right diagonal
    index_square = @current_square
    until index_square.bottom_right.nil? or !index_square.bottom_right.piece.nil? do
      index_square = index_square.bottom_right
      legal_move_list << index_square
    end
    legal_move_list << index_square.bottom_right if opponent_exists(index_square.bottom_right)

    return legal_move_list
  end
end
class Rook < Piece
  attr_reader :image
  def initialize(white = true, square = nil)
      super
      @image = '♜'.colorize(@@WhiteColor) if is_white?
      @image = '♜'.colorize(@@BlackColor) if is_black?
  end

  def legal_moves
    legal_move_list = []
    ##Above movement
    index_square = @current_square
    until index_square.above.nil? or !index_square.above.piece.nil? do
      index_square = index_square.above
      legal_move_list << index_square
    end
    legal_move_list << index_square.above if opponent_exists(index_square.above)

    ##below movement
    index_square = @current_square
    until index_square.below.nil? or !index_square.below.piece.nil? do
      index_square = index_square.below
      legal_move_list << index_square
    end
    legal_move_list << index_square.below if opponent_exists(index_square.below)

    ##left movement
    index_square = @current_square
    until index_square.left.nil? or !index_square.left.piece.nil? do
      index_square = index_square.left
      legal_move_list << index_square
    end
    legal_move_list << index_square.left if opponent_exists(index_square.left)

    ##right movement
    index_square = @current_square
    until index_square.right.nil? or !index_square.right.piece.nil? do
      index_square = index_square.right
      legal_move_list << index_square
    end
    legal_move_list << index_square.right if opponent_exists(index_square.right)

    return legal_move_list
  end
end

class Queen < Piece
  attr_reader :image
  def initialize(white = true, square = nil)
      super
      @image = '♛'.colorize(@@WhiteColor) if is_white?
      @image = '♛'.colorize(@@BlackColor) if is_black?
  end

  def legal_moves
    legal_move_list = []
    ##Above movement
    index_square = @current_square
    until index_square.above.nil? or !index_square.above.piece.nil? do
      index_square = index_square.above
      legal_move_list << index_square
    end
    legal_move_list << index_square.above if opponent_exists(index_square.above)

    ##below movement
    index_square = @current_square
    until index_square.below.nil? or !index_square.below.piece.nil? do
      index_square = index_square.below
      legal_move_list << index_square
    end
    legal_move_list << index_square.below if opponent_exists(index_square.below)

    ##left movement
    index_square = @current_square
    until index_square.left.nil? or !index_square.left.piece.nil? do
      index_square = index_square.left
      legal_move_list << index_square
    end
    legal_move_list << index_square.left if opponent_exists(index_square.left)

    ##right movement
    index_square = @current_square
    until index_square.right.nil? or !index_square.right.piece.nil? do
      index_square = index_square.right
      legal_move_list << index_square
    end
    legal_move_list << index_square.right if opponent_exists(index_square.right)

    ##Top left diagonal
    index_square = @current_square
    until index_square.top_left.nil? or !index_square.top_left.piece.nil? do
      index_square = index_square.top_left
      legal_move_list << index_square
    end
    legal_move_list << index_square.top_left if opponent_exists(index_square.top_left)

    ##Top right diagonal
    index_square = @current_square
    until index_square.top_right.nil? or !index_square.top_right.piece.nil? do
      index_square = index_square.top_right
      legal_move_list << index_square
    end
    legal_move_list << index_square.top_right if opponent_exists(index_square.top_right)

    ##Bottom left diagonal
    index_square = @current_square
    until index_square.bottom_left.nil? or !index_square.bottom_left.piece.nil? do
      index_square = index_square.bottom_left
      legal_move_list << index_square
    end
    legal_move_list << index_square.bottom_left if opponent_exists(index_square.bottom_left)

    ##Bottom right diagonal
    index_square = @current_square
    until index_square.bottom_right.nil? or !index_square.bottom_right.piece.nil? do
      index_square = index_square.bottom_right
      legal_move_list << index_square
    end
    legal_move_list << index_square.bottom_right if opponent_exists(index_square.bottom_right)

    return legal_move_list
  end
end

class King < Piece
  attr_reader :image
  def initialize(white = true, square = nil)
      super
      @image = '♚'.colorize(@@WhiteColor) if is_white?
      @image = '♚'.colorize(@@BlackColor) if is_black?
  end

  def legal_moves
    legal_move_list = []
    legal_move_list << @current_square.above unless @current_square.above.nil? or friend_exists(@current_square.above)
    legal_move_list << @current_square.below unless @current_square.below.nil? or friend_exists(@current_square.below)
    legal_move_list << @current_square.left unless @current_square.left.nil? or friend_exists(@current_square.left)
    legal_move_list << @current_square.right unless @current_square.right.nil? or friend_exists(@current_square.right)
    legal_move_list << @current_square.top_right unless @current_square.top_right.nil? or friend_exists(@current_square.top_right)
    legal_move_list << @current_square.top_left unless @current_square.top_left.nil? or friend_exists(@current_square.top_left)
    legal_move_list << @current_square.bottom_left unless @current_square.bottom_left.nil? or friend_exists(@current_square.bottom_left)
    legal_move_list << @current_square.bottom_right unless @current_square.bottom_right.nil? or friend_exists(@current_square.bottom_right)
    return legal_move_list
  end
end

end
