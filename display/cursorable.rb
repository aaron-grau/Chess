require "io/console"

module Cursorable

  KEYMAP = {
    " " => :select,
    "w" => :up,
    "a" => :left,
    "s" => :down,
    "d" => :right,
    "h" => :select,
    "\u0003" => :ctrl_c,
    "\r" => :select,
    "\e[A" => :up,
    "\e[B" => :down,
    "\e[C" => :right,
    "\e[D" => :left
  }

  MOVES = {
    left: [0, -1],
    right: [0, 1],
    up: [-1, 0],
    down: [1,0]
  }

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  def handle_key(key)
    case key
    when :ctrl_c
      exit 0
    when :select
      @selected = !@selected
      return @cursor_pos
    when :up , :left , :down, :right
      update_pos(MOVES[key])
    end
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!
    input = STDIN.getc.chr
    STDIN.echo = true
    STDIN.cooked!

    input
  end

  def update_pos(move_direction)
    new_pos = [@cursor_pos[0] + move_direction[0],
               @cursor_pos[1] + move_direction[1]]
    @cursor_pos = new_pos if @board.in_bounds?(new_pos)
  end

end
