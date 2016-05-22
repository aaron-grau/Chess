
module UndoMove

  def undo_move
    board[reverse_move[1]] = moved_piece
    moved_piece.curr_pos = reverse_move[1]
    board[reverse_move[0]] = last_captured
    curr_pos = [reverse_move[1][0], reverse_move[1][1]]
    if k_castled
      board.make_any_move([curr_pos[0], curr_pos[1] + 1], [curr_pos[0], curr_pos[1] + 3])
      board[[curr_pos[0], curr_pos[1] + 3]].can_castle = true
      board[reverse_move[1]].has_castled = false
    end
    if q_castled
      board.make_any_move([curr_pos[0], curr_pos[1] - 1], [curr_pos[0], curr_pos[1] - 4])
      board[[curr_pos[0], curr_pos[1] - 4]].can_castle = true
      board[reverse_move[1]].has_castled = false
    end
    board[reverse_move[1]].can_castle = true if disabled_castling
  end

  def save_move(move)
    @disabled_castling = false
    start, end_pos = move
    @moved_piece = board[start]
    @last_captured = board[end_pos]
    @reverse_move  = [end_pos, start]
    @disabled_castling = true if board[start].can_castle
  end

end
