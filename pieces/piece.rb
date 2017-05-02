class Piece
  attr_accessor :board, :color, :pos

  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos
  end

  def move(new_pos)
    return false unless valid_pos?(new_pos) && valid_move?(new_pos)
    @pos = new_pos
    @board.move(Move.new(@pos, new_pos, self))
  end

  def valid_move?(new_pos)
    moves.include?(new_pos)
  end

  def valid_pos?(new_pos)
    row, col = new_pos
    row.between?(0, 7) && col.between(0,7)
  end

  def to_s
    " #{symbol} "
  end

  def symbol

  end
end
