require_relative 'pieces'

class Board
  attr_reader :rows

  def initialize
    @empty_square = NullPiece.instance
    create_starting_board
  end

  def [](pos)
    raise 'invalid pos' unless valid_pos?(pos)

    row, col = pos
    @rows[row][col]
  end

  def []=(pos, piece)
    raise 'invalid pos' unless valid_pos?(pos)
    row, col = pos
    @rows[row][col] = piece
  end

  def valid_pos?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end

  def empty?
    self[pos].empty?
  end

  def move_piece
    raise 'there is no piece at the start position' if empty?(start_pos)

    piece_to_move = self[start_pos]

    raise 'Invalid move for selected piece' unlesss piece.moves.include?(end_pos)


  end

  private
  attr_reader :empty_square
  def fill_front_row(color)
    row = (color == :white) ? 6 : 1
    8.times { |col| Pawn.new(color, self, [row, col]) }
  end

  def fill_back_row(color)
    back_pieces = [
                  Rook,
                  Knight,
                  Bishop,
                  Queen,
                  King,
                  Bishop,
                  Knight,
                  Rook
                  ]

    row = (color == :white) ? 7 : 0
    back_pieces.each_with_index do |back_piece, col|
      back_piece.new(color, self, [i,j])
    end
  end

  def create_starting_board
    @rows = Array.new(8) { Array.new(8, empty_square) }
    [:white, :black].each do |color|
      fill_back_row(color)
      fill_front_row(color)
    end
  end

end
