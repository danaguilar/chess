require_relative 'Chess.rb'
class Game
  attr_accessor :chess, :players
  def initialize
    @chess = Chess.new
    @players = [:white, :black]
    @turn = 0
    @saved_turn = 0
    self.play
  end


  def play
    while true do
      system "clear" or system "cls"
      active_player = @players[@turn%2]
      chess.draw_board
      break if chess.legal_moves(active_player).length == 0
      puts "CHECK!" if chess.in_check?(active_player)
      make_move(active_player)
      @turn += 1
    end
    current_player = @players[@turn%2]
    other_player = @players[(@turn+1)%2]
    if chess.in_check?(current_player)
      puts "CHECKMATE!"
      puts "#{player_to_string(other_player)} wins the game!"
    else
      puts "STALEMATE!"
      puts "DRAW!"
    end
  end


  def player_to_string(player)
    return "white" if player == :white
    return "black" if player == :black
    return "wut?"
  end

  def make_move(active_player)
    puts "#{player_to_string(active_player).upcase} TO MOVE"
    puts "#{chess.legal_moves(active_player).length} possible moves"
    error = :none
    until error == :success
      puts "Choose a move"
      move = gets.chomp
      move_set = parse_move(move)
      error = chess.make_new_move(move_set[0],move_set[1],active_player)
      case error
      when :saved
        @saved_turn = @turn - 1
        puts "Game state saved"
      when :loaded
        @turn = @saved_turn
        error = :success
      when :bad_format
        puts "Incorrect Format"
        puts "Make sure your move is written as start - end"
        puts "Example: E2-E4"
      when :start_out_of_bounds
        puts "Your starting square is out of bounds."
        puts "Make sure the column is between A-H and the row is between 1-8"
      when :end_out_of_bounds
        puts "Your ending square is out of bounds."
        puts "Make sure the column is between A-H and the row is between 1-8"
      when :no_piece_found
        puts "There is no piece on your first square"
        puts "Choose a square that has a piece on it"
      when :not_a_color
        puts "Your color isn't recognized?"
        puts "That's weird... not your fault. Bad system I guess"
      when :cannot_move_white_piece
        puts "Cheater!"
        puts "You can only move white pieces"
      when :cannot_move_black_piece
        puts "Cheater!"
        puts "You can only move black pieces"
      when :invalid_move
        puts "Your piece can't move like that"
        puts "For more help on how to play, try an online tutorial"
      end
    end
  end
  def parse_move(move)
    if move.include?('-')
      move.upcase!
      return move.split('-')
    else
      return [move,'']
    end
  end

end

new_game = Game.new
