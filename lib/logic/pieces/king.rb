
class King < Piece
  include SteppingPiece

  def initialize(color, board, curr_pos, options = {"has_castled" => false, "can_castle" => false})
    super(color, board, curr_pos, options)
  end

  def moves(board)
    @board = board
    moves = move_king(@curr_pos)
    #king side castling legality check
    if @can_castle && @board[[@curr_pos[0], @curr_pos[1] + 3]].can_castle &&
      @board.is_empty?([@curr_pos[0], @curr_pos[1] + 1]) &&
      @board.is_empty?([@curr_pos[0], @curr_pos[1] + 2])
      moves << [@curr_pos[0], @curr_pos[1] + 2]
    end
    #queen side castling legality check
    if @can_castle && @board[[@curr_pos[0], @curr_pos[1] - 4]].can_castle &&
      @board.is_empty?([@curr_pos[0], @curr_pos[1] - 1]) &&
      @board.is_empty?([@curr_pos[0], @curr_pos[1] - 2]) &&
      @board.is_empty?([@curr_pos[0], @curr_pos[1] - 3])
      moves << [@curr_pos[0], @curr_pos[1] - 2]
    end
    moves
  end

  def inspect
    to_s
  end

  def to_s
    return "\u2654".encode("utf-8") if color == 'white'
    "\u265A".encode('utf-8')
  end
end
