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

  def initialize(color, display)
    @color = color
    @display = display
  end

  def make_comp_move(board)
    # begin
      piece_to_move = board.single_color_pieces(self.color).sample
      next_move = piece_to_move.valid_moves.sample
      board.move_piece(self.color, piece_to_move.pos, next_move)
    # rescue StandardError => e
    #   @display.notifications[:error] = e.message unless @display.notifications.nil?
    #   retry
    # end
  end

  def make_smarter_move(board)
    all_moves = []
    computer_pieces = board.single_color_pieces(self.color)
    computer_pieces.each do |piece|
      points = 0
      priority_move = false
      # want to move pieces that could be captured at their present positions
      piece.valid_moves.each do |potential_move|
        current_move = Move.new(piece.pos, potential_move, piece)
        if could_be_captured?(board, current_move.start_pos)
          priority_move = true
          current_move.reasons << ["piece could be captured at start pos"]
        end

        simulated_board = board.dup

        if !simulated_board.empty?(current_move.end_pos)
          current_move.value += PIECE_VALUES[simulated_board[current_move.end_pos].class]
          current_move.reasons << ["piece can capture opponents piece!"]
        end

        simulated_board.move_piece!(current_move.start_pos, current_move.end_pos)

        if could_be_captured?(simulated_board, current_move.end_pos)
          current_move.reasons << ["piece could be captured at end pos"]
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
    puts "#{move_to_make.reasons}" unless move_to_make.reasons.empty?
    sleep(1)
  end

  def could_be_captured?(board, pos)
    board.opponent_valid_moves(self.color).any? { |move| move == pos }
  end
end
