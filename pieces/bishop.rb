require_relative 'piece'
require_relative 'moveable/slideable'

class Bishop < Piece
  include Slideable

  def symbol
    '♝'.colorize(color)
  end

  protected
  def move_dirs
    diagonal_dirs
  end
end
