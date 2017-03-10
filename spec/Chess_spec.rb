require 'Chess'

describe Chess do
  describe Chess::Board do
    describe Chess::Board::Square do
      subject(:square) {Chess::Board::Square.new('E','4')}
      context "When linking two square" do
        it "links both squares top to bottom" do
          top_square = Chess::Board::Square.new('E','5')
          square.link(top_square,:above)
          expect(square.above).to equal(top_square)
          expect(top_square.below).to equal(square)
        end

        it "links both squares bottom to top" do
          bottom_square = Chess::Board::Square.new('E','3')
          square.link(bottom_square,:below)
          expect(square.below).to equal(bottom_square)
          expect(bottom_square.above).to equal(square)
        end

        it "links both squares left to right" do
          right_square= Chess::Board::Square.new('F','4')
          square.link(right_square,:right)
          expect(square.right).to equal(right_square)
          expect(right_square.left).to equal(square)
        end

        it "links both squares right to left" do
          left_square= Chess::Board::Square.new('D','4')
          square.link(left_square,:left)
          expect(square.left).to equal(left_square)
          expect(left_square.right).to equal(square)
        end

        it "links both squares top_right to bottom_left" do
          top_right = Chess::Board::Square.new('F','5')
          square.link(top_right,:top_right)
          expect(square.top_right).to equal(top_right)
          expect(top_right.bottom_left).to equal(square)
        end

        it "links both squares bottom_right to top_left" do
          bottom_right = Chess::Board::Square.new('F','3')
          square.link(bottom_right,:bottom_right)
          expect(square.bottom_right).to equal(bottom_right)
          expect(bottom_right.top_left).to equal(square)
        end

        it "links both squares top_left to bottom_right" do
          top_left = Chess::Board::Square.new('D','5')
          square.link(top_left,:top_left)
          expect(square.top_left).to equal(top_left)
          expect(top_left.bottom_right).to equal(square)
        end

        it "links both squares bottom_left to top_right" do
          bottom_left = Chess::Board::Square.new('D','3')
          square.link(bottom_left,:bottom_left)
          expect(square.bottom_left).to equal(bottom_left)
          expect(bottom_left.top_right).to equal(square)
        end
      end
    end
  end
end
