require_relative 'cursorable'
require 'byebug'

class Display
  include Cursorable
  require 'colorize'

  def initialize(board)
    @board = board
    @cursor_pos = [0,0]
    @selected = false
  end

  def render
    system('clear')
    @board.grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        print tile.to_s + " " unless [idx1,idx2] == @cursor_pos || @board[[idx1, idx2]].selected
        #debugger
        print tile.to_s.on_red + " " if [idx1,idx2] == @cursor_pos && !@board[[idx1, idx2]].selected
        print tile.to_s.on_yellow + " " if @board[[idx1,idx2]].selected
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
