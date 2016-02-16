class Board

  attr_reader :grid

  BLACK_PIECES = [
    Rook.new("black", self, [0,0]),
    Knight.new("black", self, [0,1]),
    Bishop.new("black", self, [0,2]),
    King.new("black", self, [0,3]),
    Queen.new("black", self, [0,4]),
    Bishop.new("black", self, [0,5]),
    Knight.new("black", self, [0,6]),
    Rook.new("black", self, [0,7])
  ]
  WHITE_PIECES = [
    Rook.new(self, [7,0]),
    Knight.new(self, [7,1]),
    Bishop.new(self, [7,2]),
    King.new(self, [7,3]),
    Queen.new(self, [7,4]),
    Bishop.new(self, [7,5]),
    Knight.new(self, [7,6]),
    Rook.new(self, [7,7])
  ]

  def initialize(set = true)
    @grid = Array.new(8){Array.new(8){" "}}
    set_board if set
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @grid[row][col] = val
  end

  def set_board
    @grid.each_index do |idx|
      if idx == 0
        @grid[idx] = BLACK_PIECES
      end
      if idx == 7
        @grid[idx] = WHITE_PIECES
      end
      if idx == 1
        @grid[idx].each_index do |idx2|
          @grid[idx][idx2] = Pawn.new("black", self, [idx,idx2])
        end
      elsif idx == 6
        @grid[idx].each_index do |idx2|
          @grid[idx][idx2] = Pawn.new(self, [idx,idx2])
        end
      end
    end
  end

  def move(pos)
    start,end_pos = pos
    start_row, start_col = start
    end_row, end_col = end_pos
    start_piece = @grid[start_row][start_col]
    legal_move?(start,end_pos)

    @grid[end_row][end_col] = start_piece
    @grid[start_row][start_col] = " "
    start_piece.curr_pos = end_pos
  end

  def legal_move?(start, end_pos)
    start_row, start_col = start
    end_row, end_col = end_pos
    piece = grid[start_row][start_col]
    raise IllegalMoveError.new("Illegal Move!") unless piece.legal_moves(self).include?(end_pos)
    piece.legal_moves(self).include?(end_pos)
  end

  def legal_moves(color)
    legal_moves = []
    pieces =
      @grid.flatten.select do |tile|
        tile.class < Piece && tile.color == color
      end
    pieces.each do |piece|
      #debugger
     legal_moves += piece.legal_moves(self)
    end
    legal_moves
  end



  def is_mate?(color)
    legal_moves(color).empty?
  end

  def in_bounds?(pos)
    pos.all?{|el| el >= 0 && el <= 7}
  end

  def is_empty?(pos)
    row, col = pos
    @grid[row][col] == " " || !in_bounds?(pos)
  end

  def in_check?(color)
    king_pos = []
    @grid.flatten.each do |tile|
      if tile.is_a?(King) && tile.color == color
        king_pos = tile.curr_pos
      end
    end
    opp_pieces =
      @grid.flatten.select do |tile|
        tile.class < Piece && tile.color != color
      end
      #debugger
    opp_pieces.any? do |piece|
      piece.moves(self).include?(king_pos)
    end
  end

  def dup
    new_board = Board.new(false)

    new_board.grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|

        if grid[idx1][idx2].class < Piece
          new_board[[idx1, idx2]] = grid[idx1][idx2].dup(new_board)
        else
          new_board[[idx1, idx2]] = grid[idx1][idx2].dup
        end

      end
    end
    new_board
  end

  def make_any_move(start_pos, end_pos)
    #take from grid at start move to end pos
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    grid[end_row][end_col] = grid[start_row][start_col]
    grid[start_row][start_col] = " "
    grid[end_row][end_col].curr_pos = end_pos
  end
end




# board2 = board.dup
# display2 = Display.new(board2)
# display2.navigate
# board2.make_any_move([6,2], [5,2])
# display2.navigate
# display.navigate
#display.navigate
# p board.in_check?("black")
# p board.in_check?("white")
# p board.is_mate?("black")
# p board.is_mate?("white")
#display.navigate
# pawn = Pawn.new('black', board, [4,4])
# pawn.has_moved = true
# p pawn.moves(board)
