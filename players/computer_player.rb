require_relative 'player'
require './gameplay/display'
require './gameplay/move'

class ComputerPlayer < Player

  PIECE_VALUES = {
    Pawn => 1,
    Knight => 3,
    Bishop => 3,
    Rook => 5,
    Queen => 9,
    King => 1
  }

  BOARD_LETTERS = ["A", "B", "C", "D", "E", "F", "G", "H"]
  BOARD_NUMBERS = ["1", "2", "3", "4", "5", "6", "7", "8"]

  attr_accessor :reasons

  def initialize(color, display)
    @color = color
    @display = display
    @reasons = ""
  end

  def make_move(board)

    @display.notifications.delete(:comp_move)
    @display.notifications.delete(:comp_reason)

    display.render

    puts "The Computer is thinking...."
    sleep(1)

    all_moves = []
    computer_pieces = board.single_color_pieces(self.color)
    opponent = self.color === :black ? :white : :black

    computer_pieces.each do |piece|
      points = 0
      piece.valid_moves.each do |potential_move|
        current_move = Move.new(piece.pos, potential_move, piece)
          # update move value based on piece's current position
          update_move_if_at_risk(board, current_move)

          # update move value based on piece's end position in the potential move
          simulated_board = board.dup

          update_move_if_kill_opp_piece(simulated_board, current_move, opponent)

          simulated_board.move_piece!(current_move.start_pos, current_move.end_pos)

          update_move_for_check(current_move, simulated_board, opponent)
          update_move_if_potential_move_at_risk(current_move, simulated_board)
          all_moves << current_move
      end
    end

    best_move = find_best_move(all_moves)
    board.move_piece(self.color, best_move.start_pos, best_move.end_pos)

    render_reasons(best_move)
    display.render
  end

  def find_best_move(moves_array)
    moves_array.shuffle.max_by(&:value)
  end

  def render_reasons(move)
    all_reasons = "COMPUTER (#{self.color.capitalize})'s reasons for making move:\n"

    if move.reasons.empty?
      all_reasons += "RANDOM MOVE\n"
    else
      move.reasons.each_with_index do |reason, idx|
        all_reasons += "#{idx+1}. #{reason[0]}\n"
      end
    end

    all_reasons += "COMPUTER (#{self.color.capitalize})'s MOVE'S TOTAL VALUE = #{move.value}"
    @display.notifications[:comp_move] = display_move(move)
    @display.notifications[:comp_reason] = all_reasons
  end

  def could_be_captured?(board, pos)
    board.opponent_valid_moves(self.color).any? { |move| move == pos }
  end

  def stringified_pos(pos)
    "#{BOARD_LETTERS[pos[1]]}#{BOARD_NUMBERS[pos[0]]}"
  end

  def display_move(move)
    start_move = stringified_pos(move.start_pos)
    end_move = stringified_pos(move.end_pos)
    return "\nCOMPUTER (#{self.color.capitalize}) moves #{move.piece.class} from #{start_move} to #{end_move}\n\n"
  end

  def update_move_if_at_risk(board, move)
    if could_be_captured?(board, move.start_pos)
      move.value += PIECE_VALUES[move.piece.class]
      reason = ["#{self.color.capitalize}'s #{move.piece.class} could be captured at #{stringified_pos(move.piece.pos)}  +#{PIECE_VALUES[move.piece.class]}"]
      move.reasons << reason
    end
  end

  def update_move_if_kill_opp_piece(simulated_board, move, opponent)
    if !simulated_board.empty?(move.end_pos)
      opp_piece = simulated_board[move.end_pos].class
      move.value += PIECE_VALUES[opp_piece]
      move.reasons << ["#{self.color.capitalize}'s #{move.piece.class} can capture #{opponent.capitalize}'s #{opp_piece} at #{stringified_pos(move.end_pos)}  +#{PIECE_VALUES[opp_piece]}"]
    end
  end

  def update_move_for_check(move, simulated_board, opponent)
    if simulated_board.in_check?(opponent) && !could_be_captured?(simulated_board, move.end_pos)
      move.value += 20
      move.reasons << ["#{self.color.capitalize}'s #{move.piece.class} can put #{opponent} in check at #{stringified_pos(move.end_pos)}  +20"]
    end
  end

  def update_move_if_potential_move_at_risk(move, simulated_board)
    if could_be_captured?(simulated_board, move.end_pos)
      move.reasons << ["If #{self.color.capitalize} moved to #{stringified_pos(move.end_pos)} #{self.color.capitalize}'s #{move.piece.class} could be captured  -#{PIECE_VALUES[move.piece.class]}"]
      move.value -= PIECE_VALUES[move.piece.class]
    end
  end
end
