require_relative 'display'
require_relative 'player'
require_relative 'move'

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

  def make_comp_move(board)
      piece_to_move = board.single_color_pieces(self.color).sample
      next_move = piece_to_move.valid_moves.sample
      board.move_piece(self.color, piece_to_move.pos, next_move)
  end

  def make_smarter_move(board)
    display.render

    puts "The Computer is thinking...."
    sleep(1)
    all_moves = []
    computer_pieces = board.single_color_pieces(self.color)
    opponent = self.color === :black ? :white : :black
    computer_pieces.each do |piece|
      points = 0
      priority_move = false
      # want to move pieces that could be captured at their present positions
      piece.valid_moves.each do |potential_move|
        current_move = Move.new(piece.pos, potential_move, piece)
        if could_be_captured?(board, current_move.start_pos)
          priority_move = true
          current_move.reasons << ["#{self.color.capitalize}'s #{current_move.piece.class} could be captured at #{piece.pos}  +#{PIECE_VALUES[piece.class]}"]
        end

        simulated_board = board.dup

        if !simulated_board.empty?(current_move.end_pos)
          opp_piece = simulated_board[current_move.end_pos].class
          current_move.value += PIECE_VALUES[opp_piece]
          current_move.reasons << ["#{self.color.capitalize}'s #{current_move.piece.class} can capture #{opponent.capitalize}'s #{opp_piece}!  +#{PIECE_VALUES[opp_piece]}"]
        end

        simulated_board.move_piece!(current_move.start_pos, current_move.end_pos)

        if simulated_board.in_check?(opponent) && !could_be_captured?(simulated_board, current_move.end_pos)
          current_move.value += 20
          current_move.reasons << ["#{self.color.capitalize}'s #{current_move.piece.class} can put #{opponent} in check!  +20"]
        end

        if could_be_captured?(simulated_board, current_move.end_pos)
          current_move.reasons << ["If #{self.color.capitalize} moved to #{current_move.end_pos} #{self.color.capitalize}'s #{current_move.piece.class} could be captured  -#{PIECE_VALUES[piece.class]}"]
          current_move.value -= PIECE_VALUES[current_move.piece.class]
        end

        if priority_move == true
          current_move.value += PIECE_VALUES[current_move.piece.class]
        end

        all_moves << current_move
      end
    end

    move_to_make = all_moves.shuffle.max_by(&:value)
    board.move_piece(self.color, move_to_make.start_pos, move_to_make.end_pos)
    all_reasons = "COMPUTER (#{self.color.capitalize})'s reasons for making move:\n"

    if move_to_make.reasons.empty?
      all_reasons += "RANDOM MOVE\n"
    else
      move_to_make.reasons.each_with_index do |reason, idx|
        all_reasons+= "#{idx+1}. #{reason[0]}\n"
      end
    end

    all_reasons += "COMPUTER (#{self.color.capitalize})'s MOVE'S TOTAL VALUE = #{move_to_make.value}"
    display.render
    display_move(move_to_make)
    puts all_reasons

  end

  def could_be_captured?(board, pos)
    board.opponent_valid_moves(self.color).any? { |move| move == pos }
  end

  def display_move(move)
    start_move = "#{BOARD_LETTERS[move.start_pos[1]]}#{BOARD_NUMBERS[move.start_pos[0]]}"
    end_move = "#{BOARD_LETTERS[move.end_pos[1]]}#{BOARD_NUMBERS[move.end_pos[0]]}"
    puts "\nCOMPUTER (#{self.color.capitalize}) moves #{move.piece.class} from #{start_move} to #{end_move}\n\n"
  end
end
