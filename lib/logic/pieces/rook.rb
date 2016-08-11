class Rook < Piece
  include SlidingPiece

  def initialize(color, board, curr_pos, options = {has_castled: false, can_castle: false})
    super(color, board, curr_pos, options)
  end

  def moves(board)
    return @moves.to_a unless @moves.nil?

    @board = board
    new_moves = move_straight(curr_pos)
    @moves = Set.new(@moves)

    new_moves
  end

  def inspect
    to_s
  end

  def to_s
    return "\u2656".encode("utf-8") if color == 'white'
    "\u265C".encode('utf-8')
  end
end
