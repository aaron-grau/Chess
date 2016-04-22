
module UndoMove

  def undo_move
    @board.make_any_move(@reverse_move[0], @reverse_move[1])
    @board.grid[@reverse_move[0][0]][@reverse_move[0][1]] = @last_captured
    curr_pos = [@reverse_move[1][0], @reverse_move[1][1]]
    if @queened
      @board[@reverse_move[1]] = Pawn.new(@color, @board, @reverse_move[1])
    end
    if @k_castled
      @board.make_any_move([curr_pos[0], curr_pos[1] + 1], [curr_pos[0], curr_pos[1] + 3])
      @board[[curr_pos[0], curr_pos[1] + 3]].can_castle = true
      @board[@reverse_move[1]].has_castled = false
    end
    if @q_castled
      @board.make_any_move([curr_pos[0], curr_pos[1] - 1], [curr_pos[0], curr_pos[1] - 4])
      @board[[curr_pos[0], curr_pos[1] - 4]].can_castle = true
      @board[@reverse_move[1]].has_castled = false
    end
    @board[@reverse_move[1]].can_castle = true if @disabled_castling
  end

end
