require 'Chess'
require 'Pieces'

describe Pieces::Piece do
  let(:board) {Chess::Board.new}
  subject(:piece) {Pieces::Piece.new(true,board.grid['2']['E'])}
  context "When checking if an opponent exists at a square" do
    context "will return true when" do
      it "the two pieces are of a different color" do
        Pieces::Piece.new(false,board.grid['3']['D'])
        expect(piece.opponent_exists(board.grid['3']['D'])).to be true
      end
    end
    context "will return false when" do
      it "square does not exist" do
        expect(piece.opponent_exists(board.grid['1']['A'].left)).to be false
      end
      it "square piece does not exist" do
        expect(piece.opponent_exists(board.grid['1']['A'])).to be false
      end
      it "piece in square is the same color as original piece" do
        Pieces::Piece.new(true,board.grid['3']['F'])
        expect(piece.opponent_exists(board.grid['3']['F'])).to be false
      end
    end
  end
end
describe Pieces::Pawn do
  let(:board){Chess::Board.new}
  subject(:pawn){Pieces::Pawn.new(true,board.grid['2']['E'])}
  subject(:black_pawn){Pieces::Pawn.new(false,board.grid['7']['E'])}
  context "The pawn's movelist contains" do
    context "if the pawn is white" do
      it "the empty square in front of it" do
        expect(pawn.legal_moves).to include('E3')
      end
      it "any squares that have an enemy to the top_left or top_right" do
        enemy1 = Pieces::Pawn.new(false,board.grid['3']['F'])
        enemy2 = Pieces::Pawn.new(false,board.grid['3']['D'])
        expect(pawn.legal_moves).to include('F3')
        expect(pawn.legal_moves).to include('D3')
      end
      it "two squares in front of it only if it hasn't moved yet" do
        pawn.has_moved = false
        expect(pawn.legal_moves).to include('E4')
      end
    end
    context "if the pawn is black" do
      it "the empty square in behind it" do
        expect(black_pawn.legal_moves).to include('E6')
      end
      it "any squares that have an enemy to the bottom_left or bottom_right" do
        enemy1 = Pieces::Pawn.new(true,board.grid['6']['F'])
        enemy2 = Pieces::Pawn.new(true,board.grid['6']['D'])
        expect(black_pawn.legal_moves). to include('F6')
        expect(black_pawn.legal_moves). to include('D6')
      end
      it "two squares in behind it only if it hasn't moved yet" do
        black_pawn.has_moved = false
        expect(black_pawn.legal_moves).to include('E5')
      end
    end
  context "The pawn's movelist should not contain" do
    context "if the pawn is white" do
      it "any square outside the game board"
      it "any square in front of it if there is a piece occupying that square"
      it "the top_right or top_left squares if there is no enemy piece on them"
      it "the square two spaces in front of the pawn if the pawn has already moved"
    end
  end
  end
end
