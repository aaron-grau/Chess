
class Pawn < Piece
  attr_accessor :has_moved

  def initialize(color = "white", board, curr_pos)
    super(color, board, curr_pos)
    @has_moved = false
  end

  def moves(board)
    @board = board
    new_moves = []
    move_up = color == "white" ? [@curr_pos[0] - 1, @curr_pos[1]] : [@curr_pos[0] + 1, @curr_pos[1]]
    move_up_first = color == "white" ? [@curr_pos[0] - 2, @curr_pos[1]] : [@curr_pos[0] + 2, @curr_pos[1]]
    capture_left = color == "white" ? [@curr_pos[0] - 1, @curr_pos[1] - 1] : [@curr_pos[0] + 1, @curr_pos[1] - 1]
    capture_right = color == "white" ? [@curr_pos[0] - 1, @curr_pos[1] + 1] : [@curr_pos[0] + 1, @curr_pos[1] + 1]

    new_moves << move_up if @board.is_empty?(move_up) && @board.in_bounds?(move_up)
    new_moves << move_up_first if @board.is_empty?(move_up_first) && !@has_moved && @board.in_bounds?(move_up_first)
    new_moves << capture_left if !@board.is_empty?(capture_left) &&
                                  @board[capture_left].color != color && @board.in_bounds?(capture_left)
                                #  debugger
    new_moves << capture_right if !@board.is_empty?(capture_right) && @board[capture_right].color != color && @board.in_bounds?(capture_right)

    new_moves
  end
  def inspect
    return "P".colorize(:green) if color == 'white'
    "P"
  end

  def to_s
    return "P".colorize(:green) if color == 'white'
    "P"
  end
end
