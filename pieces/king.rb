require_relative 'piece'
require 'colorize'
class King < Piece
  def symbol
     '♚'.colorize(color)
  end
end
