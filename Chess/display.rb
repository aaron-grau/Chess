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

  def render(legal_moves)
    system('clear')
    @board.grid.each_with_index do |row, idx1|

      row.each_with_index do |tile, idx2|
        str = (tile.to_s == " ") ? "*" : tile.to_s
        if legal_moves.include?([idx1,idx2])
          if [idx1,idx2] == @cursor_pos
            print (" " + str.to_s+ " ").red.on_light_blue.blink
          else
            print (" " + tile.to_s + " ").on_light_blue
          end
        elsif @board[[idx1,idx2]].selected
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

  def navigate(legal_moves)
    render(legal_moves)
    input = get_input
    return navigate(legal_moves) unless @selected
    @selected = false
    input
  end

end
