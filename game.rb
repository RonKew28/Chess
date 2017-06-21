require 'io/console'

require_relative 'gameplay/board'
require_relative 'players/human_player'
require_relative 'players/computer_player'

class Game
  attr_reader :board, :display, :current_player, :players

  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @players = {
      white: HumanPlayer.new(:white, @display),
      black: ComputerPlayer.new(:black, @display)
    }
    @current_player = :white
  end

  def play
    until board.checkmate?(current_player)
      begin
        if current_player == :black
          players[current_player].make_move(board)


        else
          start_pos, end_pos = players[current_player].make_move(board)
          board.move_piece(current_player, start_pos, end_pos)
        end

        swap_turn!
        notify_players

      rescue StandardError => e
        @display.notifications.delete(:comp_move) unless @display.notifications[:comp_move].nil?
        @display.notifications.delete(:comp_reason) unless @display.notifications[:comp_reason].nil?
        @display.notifications[:error] = e.message
        retry
      end
    end

    display.render
    puts "#{current_player.capitalize} is checkmated."

    nil
  end

  private

  def notify_players
    if board.in_check?(current_player)
      display.set_check!
    else
      display.uncheck!
    end
  end

  def swap_turn!
    @current_player = (current_player == :white) ? :black : :white
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
