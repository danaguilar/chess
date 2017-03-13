require 'Chess'

describe Chess do
  describe Chess::Board do
    subject(:board){Chess::Board.new}
    context "When creating a new board" do
      it "has 64 squares" do
        count_of_squares = 0
        board.grid.each do |col_name,row|
            count_of_squares += row.length
        end
        expect(count_of_squares).to eql(64)
      end
      it "matches the grid coordinates to the square's row and column" do
        rand_col = (rand(8) + 64).chr
        rand_row = (rand(7)+1).to_s
        test_square = board.grid[rand_col][rand_row]
        expect(test_square.row).to eql(rand_row)
        expect(test_square.column).to eql(rand_col)
      end
      it "will traverse bottom to top" do
        start_square = board.grid['A']['1']
        start_square = start_square.above until start_square.above.nil?
        expect(start_square).to equal(board.grid['A']['8'])
      end
    end
    context "When traversing the board" do
      it "traverses from bottom to top" do
        start_square = board.grid['A']['1']
        fail_count = 0
        until start_square.above.nil? or fail_count > 10 do
          start_square = start_square.above
          fail_count += 1
        end
        expect(start_square).to equal board.grid['A']['8']
      end
      it "traverses from one diagonal to another" do
        start_square = board.grid['A']['1']
        fail_count = 0
        until start_square.top_right.nil? or fail_count > 10 do
          start_square = start_square.top_right
          fail_count += 1
        end
        expect(start_square).to equal board.grid['H']['8']
      end
    end
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
