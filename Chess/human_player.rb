class HumanPlayer

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    display = Display.new(board, @color)
    start_pos = display.navigate
    if board.is_empty?(start_pos)
      raise IllegalMoveError.new("You picked an empty square!")
    elsif board[start_pos].color != @color
      raise IllegalMoveError.new("Pick a piece of your color.")
    end

    board[start_pos].selected = true
    end_pos = display.navigate
    board[start_pos].selected = false

    [start_pos, end_pos]
  end

end
