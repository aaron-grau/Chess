class Piece
  attr_reader :color
  attr_accessor :selected, :curr_pos

  def initialize(color = 'white', board, curr_pos)
    @color, @board, @curr_pos, @selected = color, board, curr_pos, false
  end

  def moves(board)
    raise StandardError.message("This shouldn't be called")
  end

  def to_s
    raise StandardError.message("to_s shouldn't be called")
  end

  def legal_moves(board)
    all_moves = moves(board)

    all_moves.reject do |move|
      test_board = board.dup
      test_board.make_any_move(@curr_pos, move)
      test_board.in_check?(color)
    end
  end

  def dup(new_board)
    self.class.new(color, new_board, curr_pos)
  end


end
