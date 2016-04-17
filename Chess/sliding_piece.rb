require 'byebug'
module SlidingPiece

    DIAG = [
      [-1,-1],
      [1,-1],
      [1,1],
      [-1,1]
    ]

    STRAIGHT = [
      [1,0],
      [0,1],
      [-1,0],
      [0,-1]
    ]
    def move_diag(pos)
      all_moves = possible_moves(pos,DIAG)
    end

    def move_straight(pos)
      all_moves = possible_moves(pos,STRAIGHT)
    end

    def possible_moves(pos, direction)
      new_squares = []
      direction.each do |change|
        row_c, col_c = change[0], change[1]
        pos_new = [pos[0] + row_c, pos[1] + col_c]

        while @board.in_bounds?(pos_new) && @board.is_empty?(pos_new)
          new_squares << pos_new
          row_c, col_c = row_c + change[0], col_c + change[1]
          pos_new = [pos[0] + row_c, pos[1] + col_c]
        end

        if @board.in_bounds?(pos_new) &&
           !@board[pos_new].is_a?(String) &&
           @board[pos_new].color != self.color
          new_squares << pos_new
        end
      end

      new_squares
    end

end
