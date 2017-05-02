require_relative 'pieces'

class Board
  attr_reader :rows

  def initialize
    @rows = Array.new(8) { Array.new(8) { nil } }
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
    row, col = pos
    row.between?(0, 7) && col.between(0,7)
  end

  def empty?
    self[pos].nil?
  end

  def move_piece
    raise 'there is no piece at the start position' if empty?(start_pos)

    piece_to_move = self[start_pos]

    raise 'Invalid move for selected piece' unless piece.moves.include?(end_pos)


  end

  private
  attr_reader :empty_square
  def fill_front_row(color, row_num)
    8.times { |col_num| Pawn.new(color, self, [row_num, col_num]) }
  end

  def fill_back_row(color, row_num)
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

    back_pieces.each_with_index do |back_piece, col_num|
      back_piece.new(color, self, [row_num,j])
    end
  end

  def create_starting_board
    @rows[0] = fill_back_row(:black, 0)
    @rows[1] = fill_front_row(:black, 1)
    @rows[6] = fill_front_row(:white, 6)
    @rows[7] = fill_back_row(:white, 7)
  end

end
