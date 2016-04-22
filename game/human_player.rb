class HumanPlayer

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    display = Display.new(board, @color)
    start_pos = display.navigate([])
    if board.is_empty?(start_pos)
      raise IllegalMoveError.new("")
    elsif board[start_pos].color != @color
      raise IllegalMoveError.new("")
    end

    board[start_pos].selected = true
    legal_moves = board[start_pos].legal_moves(board)
    end_pos = display.navigate(legal_moves)
    board[start_pos].selected = false

    [start_pos, end_pos]
  end

end