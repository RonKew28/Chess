class Piece
  attr_accessor :board, :color, :pos

  def initialize(color, board, pos)
    raise 'invalid color' unless [:white, :black].include?(color)
    raise 'invalid pos' unless board.valid_pos?(pos)

    @color, @board, @pos = color, board, pos

    board.add_piece(self, pos)
  end

  def empty?
    self.is_a?(NullPiece) ? true : false
  end

  def name
    self.class
  end

  def to_s
    " #{symbol} "
  end

  def symbol

  end

  def valid_moves
    moves.reject { |end_pos| move_into_check?(end_pos) }
  end

  private
  def move_into_check?(end_pos)
    test_board = board.dup
    test_board.move_piece!(pos, end_pos)
    test_board.in_check?(color)
  end
end
