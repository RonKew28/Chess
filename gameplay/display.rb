require 'colorize'
require_relative 'cursor'
require_relative 'board'

class Display
  attr_reader :board, :notifications, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
    @notifications = {}
    @reasons
  end

  def build_grid
  @board.rows.map.with_index do |row, i|
    "#{i+1}  " + build_row(row, i)
  end
end

def reset!
  @notifications.delete(:error)
end

def uncheck!
  @notifications.delete(:check)
end

def set_check!
  @notifications[:check] = "Check!"
end

def build_row(row, i)
  j = 0
  current_row = row.inject("") do |line, piece|
    pos = [i, j]
    j += 1
    line + build_square(pos, piece)
  end
  return current_row
end


  def build_square(pos, piece)
    if pos == cursor.cursor_pos && cursor.selected
      background = :light_green
    elsif pos == cursor.cursor_pos
      background = :light_red
    elsif (pos[0] + pos[1]).odd?
      background = :cyan
    else
      background = :blue
    end
    stringified_piece = piece ? piece.to_s : "   "
    square = " #{stringified_piece} ".colorize(background: background)
    return square
  end

  def render
    system("clear")
    puts "Use the arrow keys, WASD, or vim to move. Press space or enter to confirm move."
    puts "     A    B    C    D    E    F    G    H"
    puts build_grid

    @notifications.each do |key, val|
      puts "#{val}"
    end
  end
end
