require_relative 'piece'
require_relative 'stepable'

class Knight < Piece
  include Stepable

  KNIGHT_MOVE_DIRS = [
                      [-2, -1],
                      [-1, -2],
                      [-2, 1],
                      [-1, 2],
                      [1, -2],
                      [2, -1],
                      [1, 2],
                      [2, 1]
                    ]
  def symbol
    '♞'.colorize(color)
  end

  def move_diffs
    KNIGHT_MOVE_DIRS
  end
end
