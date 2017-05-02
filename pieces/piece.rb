class Piece
  attr_accessor :board, :color, :pos

  def initialize(board, color, pos)
    @board, @color, @pos = board, color, pos
  end
end
