require_relative 'piece'

class Pawn < Piece

  def symbol
    '♟'.colorize(color)
  end

  private
  def has_not_moved?
    pos[0] == ((color == :white) ? 6 : 1)
  end

  def forward_dir
    (color == :white) ? -1 : 1
  end

  def moves
    moves = []

    i, j = pos
    one_step = [i + forward_dir, j]
    
    if board.valid_pos?(one_step) && board.empty?(one_step)
      moves << one_step
    end

    if has_not_moved?
      two_step = [i + 2 * forward_dir, j]
      moves << two_step if board.empty?(two_step)
    end

    potential_attacks = [ [i + forward_dir, j - 1], [i + forward_dir, j + 1] ]
    potential_attacks.each do |attack_pos|
      if board.valid_pos?(attack_pos) && board.empty?(attack_pos) && board[attack_pos].color != @color
        moves << attack_pos
      end
    end

    steps
  end

end
