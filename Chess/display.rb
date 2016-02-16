require_relative 'cursorable'
require 'byebug'

class Display
  include Cursorable
  require 'colorize'

  def initialize(board, color = "black")
    @board = board
    @cursor_pos = color == "black" ? [0, 0] : [7, 0]
    @selected = false
  end

  def render
    system('clear')
    @board.grid.each_with_index do |row, idx1|

      row.each_with_index do |tile, idx2|
        str = (tile.to_s == " ") ? "*" : tile.to_s
        if @board[[idx1,idx2]].selected
          print (" " + tile.to_s.yellow + " ").on_light_white if (idx2 + idx1)%2 == 0
          print (" " + tile.to_s.yellow + " ").on_light_black if (idx2 + idx1)%2 == 1
        elsif [idx1,idx2] == @cursor_pos
          print (" " + str + " ").red.on_light_white.blink if (idx2 + idx1)%2 == 0
          print (" " + str + " ").red.on_light_black.blink if (idx2 + idx1)%2 == 1
        else
          print (" " + tile.to_s + " ").on_light_white if (idx2 + idx1)%2 == 0
          print (" " + tile.to_s + " ").on_light_black if (idx2 + idx1)%2 == 1
        end
      end
      print "\n"
    end
  end

  def navigate
    render
    input = get_input
    return navigate unless @selected
    @selected = false
    input
  end

end
