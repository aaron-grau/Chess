class Knight < Piece
  include SteppingPiece

  def initialize(color = "white", board, curr_pos)
    super(color, board, curr_pos)
  end

  def moves(board)
    @board = board
    move_knight(@curr_pos)
  end

  def inspect
    return "N".colorize(:green) if color == 'white'
    "N"
  end

  def to_s
    return "N".colorize(:green) if color == 'white'
    "N"
  end
end
