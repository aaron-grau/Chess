class Bishop < Piece
  include SlidingPiece

  def initialize(color, board, curr_pos, options = {"has_castled" => false, "can_castle" => false})
    super(color, board, curr_pos, options)
  end

  def moves(board)
    @board = board
    move_diag(curr_pos)
  end

  def inspect
    to_s
  end

  def to_s
    return "\u2657".encode("utf-8") if color == 'white'
    "\u265D".encode('utf-8')
  end
end
