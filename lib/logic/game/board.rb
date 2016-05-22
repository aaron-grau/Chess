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
    grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    grid[row][col] = val
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

  def get_pieces(color)
    grid.flatten.select do |tile|
      tile.class < Piece && tile.color == color
    end
  end

  def in_check?(color)
    king_pos = color == "white" ? w_king.curr_pos : b_king.curr_pos
    opp_color = color == "white" ? "black" : "white"
    opp_pieces = get_pieces(opp_color)

    opp_pieces.any? do |piece|
      piece.moves(self).include?(king_pos)
    end
  end

  def is_empty?(pos)
    row, col = pos
    !in_bounds?(pos) || self[[row, col]] == " "
  end

  def is_mate?(color)
    in_check?(color) && legal_moves(color).empty?
  end

  def stalemate?(color)
    !in_check?(color) && legal_moves(color).empty?
  end

  def legal_moves(color)
    legal_moves = []
    pieces = get_pieces(color)

    pieces.each do |piece|
      legal_moves += piece.legal_moves(self)
    end

    legal_moves
  end

  def all_moves_with_start(color)
    all_moves = []
    pieces = get_pieces(color)

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

    pieces = get_pieces(color)

    pieces.each do |piece|
       piece_moves = piece.legal_moves(self)
       piece_moves.each do |target|
         legal_moves << [piece.curr_pos, target]
       end
    end

    legal_moves
  end

  def make_any_move(start_pos, end_pos, real_board_move = false)
    start_piece = self[start_pos]

    legal_move?(start_pos, end_pos) if real_board_move
    start_piece.can_castle = false if start_piece.class == Rook

    if start_piece.class == King
      castled = castling(start_piece, start_pos, end_pos)
      return castled unless castled.nil?
    end

    move!(start_pos, end_pos)
    return "queened" if queened?(start_piece, end_pos[0], end_pos[1], end_pos)
    start_piece.curr_pos = end_pos

    nil
  end

  def move(pos)
    make_any_move(pos[0], pos[1], true)
  end

  private

  def move!(start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = " "
  end

  def queened?(start_piece, end_row, end_col, end_pos)
    if start_piece.class == Pawn && (end_row == 0 || end_row == 7)
      self[end_pos] = Queen.new(start_piece.color, self, end_pos)
      return true
    end

    false
  end

  def set_board
    grid.each_index do |idx|
      case idx
      when 0
        self.grid[idx] = BLACK_PIECES
      when 7
        self.grid[idx] = WHITE_PIECES
      when 1
        set_pawns("black",idx)
      when 6
        set_pawns("white", idx)
      end
    end
  end

  def set_pawns(color, row)
    grid[row].each_index do |col|
      self[[row, col]] = Pawn.new(color, self, [row, col])
    end
  end

  def castling(king, start_pos, end_pos)
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    king.can_castle = false

    if end_col == 6 && start_col == 4
      castle!(king, start_pos, end_pos, 3, 1)
      return "k_castled"
    elsif end_col == 2 && start_col == 4
      castle!(king, start_pos, end_pos, -4, -1)
      return "q_castled"
    end

    nil
  end

  def castle!(king, start_pos, end_pos, rook_start, rook_end)
    start_row, start_col = start_pos
    end_row, end_col = end_pos

    rook = self[[start_row, start_col + rook_start]]
    move!([start_row, start_col + rook_start], [start_row, start_col + rook_end])
    rook.curr_pos = [start_row, start_col + rook_end]

    king.has_castled = true
    move!(start_pos, end_pos)
    king.curr_pos = end_pos

    king.can_castle = false
  end

  def board_from_json(new_board)
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |tile, col|
        piece = new_board[row_idx][col]
        if piece["piece"] != "String"
          self[[row_idx, col]] = create_piece_from_json(piece, row_idx, col)
          if piece["piece"] == "King"
            @w_king = self[[row_idx, col]] if piece["color"] == "white"
            @b_king = self[[row_idx, col]] if piece["color"] == "black"
          end
        end
      end
    end
  end

  def create_piece_from_json(piece, row, col)
    piece["piece"].constantize.new(
      piece["color"],
      self,
      [row, col],
      {has_castled: piece["has_castled"], can_castle: piece["can_castle"]}
    )
  end

end
