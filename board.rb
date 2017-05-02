require_relative 'pieces'

class Board
  attr_reader :rows, :empty_square

  def self.opp_color(own_color)
    color == :white ? :black : :white
  end

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
    row, col = pos
    row.between?(0, 7) && col.between?(0,7)
  end

  def empty?(pos)
    self[pos].empty?
  end

  def in_check?(own_color)
    opp_pieces = pieces(Board.opp_color(own_color))
    opp_moves = []
    opp_pieces.each do |piece|
      opp_moves += piece.moves
    end

    opp_moves.include?(find_king(own_color).pos)
  end

  def checkmate?(color)
    return false unless in_check?(color)

    pieces.select { |p| p.color == color }.all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def all_pieces
    @rows.flatten.reject { |piece| piece.empty? }
  end

  def single_color_pieces(color)
    all_pieces.select { |piece| piece.color == color }
  end

  def find_king(color)
    single_color_pieces(color).find { |piece| piece.is_a?(King) }
  end

  def move_piece(turn_color, start_pos, end_pos)
    raise 'there is no piece at the start position' if empty?(start_pos)

    piece = self[start_pos]

    raise 'You can only move your own pieces' if piece.color != turn_color
    raise 'Invalid move for selected piece' unless piece.moves.include?(end_pos)
    raise 'You cannot move into check' unless piece.valid_moves.include?(end_pos)

    move_piece!(start_pos, end_pos)
  end

  # moves without performing checks
  def move_piece!(start_pos, end_pos)
    piece = self[start_pos]
    raise 'piece cannot move like that' unless piece.moves.include?(end_pos)

    self[end_pos] = piece
    self[start_pos] = nil
    piece.pos = end_pos
  end

  def add_piece(piece, pos)
    raise 'position not empty' unless empty?(pos)
    self[pos] = piece
  end

  def dup
    dupped_board = Board.new

    all_pieces.each do |piece|
      piece.class.new(piece.color, dupped_board, piece.pos)
    end

    dupped_board
  end

  private
  attr_reader :empty_square
  def fill_front_row(color, row_num)
    front_piece_classes = [Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn, Pawn]
    front_pieces = []
    front_piece_classes.each_with_index do |front_piece, col_num|
      front_pieces << front_piece.new(color, self, [row_num, col_num])
    end
    front_pieces
    # 8.times { |col_num| Pawn.new(color, self, [row_num, col_num]) }s
  end

  def fill_back_row(color, row_num)
    back_piece_classes = [
                  Rook,
                  Knight,
                  Bishop,
                  Queen,
                  King,
                  Bishop,
                  Knight,
                  Rook
                  ]
    back_pieces = []
    back_piece_classes.each_with_index do |back_piece, col_num|
      back_pieces << back_piece.new(color, self, [row_num, col_num])
    end
    back_pieces
  end

  def create_starting_board
    @rows = Array.new(8) { Array.new(8, empty_square) }
    @rows[0] = fill_back_row(:black, 0)
    @rows[1] = fill_front_row(:black, 1)
    @rows[6] = fill_front_row(:white, 6)
    @rows[7] = fill_back_row(:white, 7)
  end

end
