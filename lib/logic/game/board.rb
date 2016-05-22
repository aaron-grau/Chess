class Board

  attr_accessor :grid, :b_king, :w_king

  def initialize(new_grid = nil)
    @grid = Array.new(8){Array.new(8){" "}}
    if new_grid.nil?
      set_board
      @w_king = self[[7, 4]]
      @b_king = self[[0, 4]]
    else
      board_from_json(new_grid)
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @grid[row][col] = val
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

  def legal_move?(start, end_pos)
    start_row, start_col = start
    end_row, end_col = end_pos
    piece = grid[start_row][start_col]

    unless piece.legal_moves(self).include?(end_pos)
      raise IllegalMoveError.new("Illegal Move!")
    end

    true
  end

  def in_bounds?(pos)
    pos.all?{|el| el >= 0 && el <= 7}
  end

  def in_check?(color)
    king_pos = color == "white" ? @w_king.curr_pos : @b_king.curr_pos

    opp_pieces = []
    @grid.each do |row|
      row.each do |tile|
        opp_pieces << tile if tile.class < Piece && tile.color != color
      end
    end

    opp_pieces.any? do |piece|
      piece.moves(self).include?(king_pos)
    end
  end

  def is_empty?(pos)
    row, col = pos
    !in_bounds?(pos) || @grid[row][col] == " "
  end

  def is_mate?(color)
    in_check?(color) && legal_moves(color).empty?
  end

  def stalemate?(color)
    !in_check?(color) && legal_moves(color).empty?
  end

  def legal_moves(color)
    legal_moves = []

    pieces =
      @grid.flatten.select do |tile|
        tile.class < Piece && tile.color == color
      end

    pieces.each do |piece|
      legal_moves += piece.legal_moves(self)
    end

    legal_moves
  end

  def all_moves_with_start(color)
    all_moves = []

    pieces =
      @grid.flatten.select do |tile|
        tile.class < Piece && tile.color == color
      end
    pieces.each do |piece|
       piece_moves = piece.moves(self)
       piece_moves.each do |target|
         all_moves << [piece.curr_pos, target]
       end
    end

    all_moves
  end

  def legal_moves_with_start(color)
    legal_moves = []

    pieces =
      @grid.flatten.select do |tile|
        tile.class < Piece && tile.color == color
      end

    pieces.each do |piece|
       piece_moves = piece.legal_moves(self)
       piece_moves.each do |target|
         legal_moves << [piece.curr_pos, target]
       end
    end

    legal_moves
  end

  def make_any_move(start_pos, end_pos, real_board_move = false)
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    start_piece = @grid[start_row][start_col]

    legal_move?(start_pos, end_pos) if real_board_move
    start_piece.can_castle = false if start_piece.class == Rook

    if start_piece.class == King
      castled = castling(start_piece, start_pos, end_pos)
      return castled unless castled.nil?
    end

    move!(start_pos, end_pos)
    return "queened" if queened?(start_piece, end_row, end_col, end_pos)
    start_piece.curr_pos = end_pos

    nil
  end

  def move(pos)
    make_any_move(pos[0], pos[1], true)
  end

  private

  def move!(start_pos, end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    @grid[end_row][end_col] = @grid[start_row][start_col]
    @grid[start_row][start_col] = " "
  end

  def queened?(start_piece, end_row, end_col, end_pos)
    if start_piece.class == Pawn && (end_row == 0 || end_row == 7)
      @grid[end_row][end_col] = Queen.new(start_piece.color, self, end_pos)
      return true
    end

    false
  end

  def set_board
    @grid.each_index do |idx|
      case idx
      when 0
        @grid[idx] = BLACK_PIECES
      when 7
        @grid[idx] = WHITE_PIECES
      when 1
        set_pawns("black",idx)
      when 6
        set_pawns("white", idx)
      end
    end
  end

  def set_pawns(color, row)
    @grid[row].each_index do |idx2|
      @grid[row][idx2] = Pawn.new(color, self, [row,idx2])
    end
  end

  def castling(king, start_pos, end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos

    if end_col == 6 && start_col == 4
      k_castle(king, start_pos, end_pos)
      return "k_castled"
    elsif end_col == 2 && start_col == 4
      q_castle(king, start_pos, end_pos)
      return "q_castled"
    else
      king.can_castle = false
    end

    nil
  end

  def k_castle(king, start_pos, end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    rook = @grid[start_row][start_col + 3]
    @grid[start_row][start_col + 3] = " "
    @grid[start_row][start_col + 1] = rook
    rook.curr_pos = [start_row, start_col + 1]
    king.has_castled = true
    @grid[end_row][end_col] = @grid[start_row][start_col]
    @grid[start_row][start_col] = " "
    king.curr_pos = end_pos
    king.can_castle = false
  end

  def q_castle(king, start_pos, end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    rook = @grid[start_row][start_col - 4]
    @grid[start_row][start_col - 4] = " "
    @grid[start_row][start_col - 1] = rook
    rook.curr_pos = [start_row, start_col - 1]
    king.has_castled = true
    @grid[end_row][end_col] = @grid[start_row][start_col]
    @grid[start_row][start_col] = " "
    king.curr_pos = end_pos
    king.can_castle = false
  end

  def board_from_json(new_board)
    @grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        piece = new_board[idx1][idx2]
        if piece["piece"] != "String"
          @grid[idx1][idx2] = piece["piece"].constantize.new(
            piece["color"],
            self,
            [idx1, idx2],
            {has_castled: piece["has_castled"], can_castle: piece["can_castle"]}
          )
          if piece["piece"] == "King"
            @w_king = self[[idx1, idx2]] if piece["color"] == "white"
            @b_king = self[[idx1, idx2]] if piece["color"] == "black"
          end
        end
      end
    end
  end

end
