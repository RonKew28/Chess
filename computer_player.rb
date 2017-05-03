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
    @reasons = []
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
          current_move.reasons << ["piece can capture opponents piece!!!!!"]
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


# class CPU
#   attr_reader :color
#
#   PIECE_VALUES = {
#     Pawn => 1,
#     Knight => 3,
#     Bishop => 3,
#     Rook => 5,
#     Queen => 9,
#     King => 1
#   }
#
#   def initialize(game, board, color)
#     @game, @color, @board = game, color, board
#     @moves = 0
#     @opp = Board.opp(@color)
#     @show_reasoning = false
#   end
#
#   def make_move
#     wait_a_little
#     move = choose_best_move
#     puts "#{move.piece}:  #{move.reasons.join(", ")}" if @show_reasoning
#     @board.move(move)
#   end
#
#   private
#
#   def wait_a_little
#     sleep(0.15 + 0.1 * rand(2))
#   end
#
#   def choose_best_move
#     move_scores = apply_logic_chain(@board.all_valid_moves(@color))
#     best_move(move_scores)
#   end
#
#   def best_move(moves)
#     moves.shuffle.max_by(&:value)
#   end
#
#   def apply_logic_chain(moves)
#     moves.each do |move|
#       points = 0
#       points += attacking_points(move)
#       points += piece_development_points(move)
#       points += lead_to_self_in_check_points(move)
#       points += tactical_retreat_points(move)
#       points += puts_self_at_risk_points(move)
#       points += checkmate_points(move)
#       move.value = points
#     end
#   end
#
#   def dumb_select(move)
#     @board[*move.to] && @board[*move.to].color == @opp ? 3 : 0
#   end
#
#   def attacking_points(move)
#     other_piece = @board[*move.to]
#     fake_move(move)
#     at_risk = at_risk?(move.to)
#     our_value = PIECE_VALUES[move.piece.class]
#     their_value = PIECE_VALUES[other_piece.class]
#     points = 0
#
#     if @board.in_check?(@opp) && !at_risk
#       points += puts_in_check_wo_risk(move)
#     end
#
#     if other_piece && !at_risk && their_value > our_value
#       points += kills_greater_wo_risk(move, their_value, our_value)
#     end
#
#
#     if other_piece && at_risk && their_value > our_value
#       points += kills_greater_w_risk(move, their_value, our_value)
#     end
#
#     if other_piece && !at_risk && their_value <= our_value
#       points += kills_lesser_or_equal_wo_risk(move, their_value, our_value)
#     end
#
#     undo_fake_move(move)
#     points
#   end
#
#   def puts_in_check_wo_risk(move)
#     move.reasons << "Putting in check without risk!" if @show_reasoning
#     15
#   end
#
#   def kills_greater_wo_risk(move, their_value, our_value)
#     move.reasons << "Killing greater without risk!" if @show_reasoning
#     (their_value - our_value) * 8
#   end
#
#   def kills_greater_w_risk(move, their_value, our_value)
#     move.reasons << "Killing greater WITH risk!" if @show_reasoning
#     7 + ((their_value - our_value) * 4)
#   end
#
#   def kills_lesser_or_equal_wo_risk(move, their_value, our_value)
#     move.reasons << "Killing lesser or equal without risk!" if @show_reasoning
#     1 + (their_value - our_value)
#   end
#
#   def piece_development_points(move)
#     our_value = PIECE_VALUES[move.piece.class]
#     points = move.to[0].between?(2, 5) ? 1 : 0
#     move.reasons << "Piece development point!" if @show_reasoning && points > 0
#     points
#   end
#
#   def lead_to_self_in_check_points(move)
#     fake_move(move)
#     points = checkable? ? -20 : 0
#     undo_fake_move(move)
#     move.reasons << "Leads to self in check..." if @show_reasoning && points < 0
#     points
#   end
#
#   def tactical_retreat_points(move)
#     points = 0
#     if at_risk?(move.from)
#       fake_move(move)
#       points += PIECE_VALUES[move.piece.class] if !at_risk?(move.to)
#       undo_fake_move(move)
#     end
#     move.reasons << "Retreat value of #{points}!" if @show_reasoning && points > 0
#     points
#   end
#
#   def puts_self_at_risk_points(move)
#     points = 0
#     if !at_risk?(move.from)
#       fake_move(move)
#       points -= PIECE_VALUES[move.piece.class] if at_risk?(move.to)
#       undo_fake_move(move)
#     end
#     move.reasons << "Puts self at risk..." if @show_reasoning && points < 0
#     points
#   end
#
#   def checkmate_points(move)
#     fake_move(move)
#     points = @board.checkmate?(@opp) ? Float::INFINITY : 0
#     undo_fake_move(move)
#     move.reasons << "Leads to checkmate!" if @show_reasoning && points > 0
#     points
#   end
#
#   def fake_move(move)
#     piece = move.piece
#     @saved_tile_contents = @board[*move.to]
#     @saved_move_state = piece.moved
#
#     @board[*move.from] = nil
#     @board[*move.to] = piece
#     piece.pos = move.to
#     piece.moved = true
#   end
#
#   def at_risk?(location)
#     @board.all_valid_moves(@opp).any? { |move| move.to == location }
#   end
#
#   def checkable?
#     @board.all_valid_moves(@opp).map(&:to).include?(@board.king_pos(@color))
#   end
#
#   def undo_fake_move(move)
#     piece = move.piece
#     @board[*move.to] = @saved_tile_contents
#     @board[*move.from] = move.piece
#     piece.pos = move.from
#     piece.moved = @saved_move_state
#   end
