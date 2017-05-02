require_relative 'piece'

class Queen < Piece
  def symbol
    '♛'.colorize(color)
  end
end
