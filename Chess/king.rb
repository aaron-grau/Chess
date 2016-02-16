class King < Piece
  include SteppingPiece

  def initialize(color = "white", board, curr_pos)
    super(color, board, curr_pos)
  end

  def moves(board)
    @board = board
    move_king(@curr_pos)
  end

  def inspect
    to_s
  end

  def to_s
    return "\u2654".encode("utf-8") if color == 'white'
    "\u265A".encode('utf-8')
  end
end
