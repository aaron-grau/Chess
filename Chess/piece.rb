class Piece
  attr_reader :color, :curr_pos
  def initialize(color = 'white', board, curr_pos)
    @color = color
    @board = board
    @curr_pos = curr_pos
  end

  def move(board)
    @board = board
   raise StandardError.message("This shouldn't be called")
  end
  def to_s
   raise StandardError.message("to_s shouldn't be called")
  end
end
