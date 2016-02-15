class Rook < Piece
  include SlidingPiece

  def initialize(color = "white",board, curr_pos)
    super(color, board, curr_pos)
  end

  def moves(board)
    @board = board
    move_straight(curr_pos)
  end

  def inspect
    to_s
  end
  
  def to_s
    return "R".colorize(:green) if color == 'white'
    "R"
  end
end
