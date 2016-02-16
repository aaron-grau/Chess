class HumanPlayer

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    display = Display.new(board)
    start_pos = display.navigate
    raise IllegalMoveError.new("You picked an empty square!") if board.is_empty?(start_pos)
    raise IllegalMoveError.new("Pick a piece of your color.") if board[start_pos].color != @color
    board[start_pos].selected = true
    end_pos = display.navigate
    board[start_pos].selected = false
    [start_pos, end_pos]
  end

end
