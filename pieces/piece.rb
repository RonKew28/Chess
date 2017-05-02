class Piece
  attr_accessor :board, :color, :pos

  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos
  end

  def move(new_pos)
    return false unless valid_pos?(new_pos) && valid_move?(new_pos)
  end

  def valid_move?(new_pos)
    moves.include?(new_pos)
  end

  def valid_pos?(new_pos)
    row, col = new_pos
    row.between?(0, 7) && col.between(0,7)
  end
end
