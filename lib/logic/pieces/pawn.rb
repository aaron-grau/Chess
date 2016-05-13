class Pawn < Piece

  def initialize(color, board, curr_pos, options = {"has_castled" => false, "can_castle" => false})
    super(color, board, curr_pos, options)
  end

  def moves(board)
    new_moves = []
    @cur_row, @cur_col = @curr_pos[0], @curr_pos[1]

    move_up(new_moves, board)
    capture_left(new_moves, board)
    capture_right(new_moves, board)

    new_moves
  end

  def inspect
    to_s
  end

  def to_s
    return "\u2659".encode("utf-8") if color == 'white'
    "\u265F".encode('utf-8')
  end

  def dup(new_board)
    self.class.new(color, new_board, curr_pos)
  end

  private

  def capture_left(new_moves, board)
    capture_left = color == "white" ? [@cur_row - 1, @cur_col - 1] : [@cur_row + 1, @cur_col - 1]
    if !board.is_empty?(capture_left) &&
        board[capture_left].color != color &&
        board.in_bounds?(capture_left)
          new_moves << capture_left
    end
  end

  def capture_right(new_moves, board)
    capture_right = color == "white" ? [@cur_row - 1, @cur_col + 1] : [@cur_row + 1, @cur_col + 1]
    if !board.is_empty?(capture_right) &&
        board[capture_right].color != color &&
        board.in_bounds?(capture_right)
          new_moves << capture_right
    end
  end

  def move_up(new_moves, board)
    move_up = color == "white" ? [@cur_row - 1, @curr_pos[1]] : [@cur_row + 1, @curr_pos[1]]
    move_up_first = color == "white" ? [@cur_row - 2, @cur_col] : [@cur_row + 2, @cur_col]
    if board.is_empty?(move_up)
      new_moves << move_up if board.in_bounds?(move_up)
      if board.is_empty?(move_up_first) && color == "white" && @curr_pos[0] == 6
        new_moves << move_up_first
      elsif board.is_empty?(move_up_first) && color == "black" && @curr_pos[0] == 1
        new_moves << move_up_first
      end
    end
  end

end
