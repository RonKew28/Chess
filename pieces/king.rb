require_relative 'piece'
require_relative 'moveable/stepable'

class King < Piece
  include Stepable

  KING_MOVE_DIRS = [
                      [-1, -1],
                      [-1, 0],
                      [-1, 1],
                      [0, -1],
                      [0, 1],
                      [1, -1],
                      [1, 0],
                      [1, 1]
                    ]
  def symbol
     '♚'.colorize(color)
  end

  protected

  def move_diffs
    KING_MOVE_DIRS
  end

end
