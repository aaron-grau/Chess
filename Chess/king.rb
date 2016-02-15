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
    return "K".colorize(:green) if color == 'white'
    "K"
  end

  def to_s
    return "K".colorize(:green) if color == 'white'
    "K"
  end
end
