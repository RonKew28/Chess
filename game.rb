require 'io/console'

require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

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
          players[current_player].make_smarter_move(board)

          ask_player_to_continue
        else
          start_pos, end_pos = players[current_player].make_move(board)
          board.move_piece(current_player, start_pos, end_pos)
        end

        swap_turn!
        notify_players

      rescue StandardError => e
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

  def ask_player_to_continue
    puts "Press any key to continue"
    STDIN.getch
  end

  def swap_turn!
    @current_player = (current_player == :white) ? :black : :white
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
