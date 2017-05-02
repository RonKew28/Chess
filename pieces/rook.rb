require_relative 'piece'


class Rook < Piece
  def symbol
    '♜'.colorize(color)
  end
end
