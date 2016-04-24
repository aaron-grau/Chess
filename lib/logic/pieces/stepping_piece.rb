module SteppingPiece

  KNIGHTS = [
    [-2,1],
    [-2,-1],
    [2,1],
    [2,-1],
    [1,2],
    [1,-2],
    [-1,2],
    [-1,-2]
  ]

  KING = [
    [1,0],
    [0,1],
    [-1,0],
    [0,-1],
    [-1,-1],
    [1,-1],
    [1,1],
    [-1,1]
  ]

  def move_king(pos)
    possible_moves(pos, KING)
  end

  def move_knight(pos)
    possible_moves(pos, KNIGHTS)
  end


  def possible_moves(pos, direction)
    all_moves = []
    direction.each do |change|
      new_pos = [change[0] + pos[0], change[1] + pos[1]]
      if @board.in_bounds?(new_pos) &&
        (@board.is_empty?(new_pos) || @board[new_pos].color != self.color)
        all_moves << new_pos
      end
    end

    all_moves
  end

end
