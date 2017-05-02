require 'colorize'
require_relative 'cursor'
require_relative 'board'
require 'byebug'

class Display
  attr_reader :board, :notifications, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
    @notifcations = {}
  end

  def build_grid
  @board.rows.map.with_index do |row, i|
    build_row(row, i)
  end
end

def build_row(row, i)
  j = 0
  this_line = row.inject("") do |line, piece|
    pos = [i, j]
    j += 1
    line + build_square(pos, piece)
  end
  return this_line
end

  def build_square(pos, piece)
    if pos == cursor.cursor_pos && cursor.selected
      background = :light_green
    elsif pos == cursor.cursor_pos
      background = :light_red
    elsif (pos[0] + pos[1]).odd?
      background = :light_blue
    else
      background = :light_yellow
    end
    stringified_piece = piece ? piece.to_s : "   "
    square = " #{stringified_piece} ".colorize(background: background)
    return square
  end

  def render
    system("clear")
    puts "Make your move"
    puts build_grid
  end
end