class Piece
  attr_reader :color
  attr_accessor :selected, :curr_pos, :board, :can_castle

  def initialize(color = 'white', board, curr_pos)
    @color, @board, @curr_pos, @selected = color, board, curr_pos, false
    @can_castle = false;
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
      save_move(move)
      @castle = false
      @queened = false
      special_move = @board.make_any_move(@curr_pos, move)
      @queened = special_move == "queened"
      @k_castle = special_move == "k_castled"
      flag = @board.in_check?(color)
      undo_move

      flag
    end
  end


  def dup(new_board)
    self.class.new(color, new_board, curr_pos)
  end


  private

  def save_move(end_pos)
    @disabled_castling = false
    end_row, end_col = end_pos
    @last_captured = @board.grid[end_row][end_col]
    @reverse_move  = [end_pos, @curr_pos]
    @disabled_castling = true if @can_castle
  end

  def undo_move
    @can_castle = true if @disabled_castling
    @board.make_any_move(@reverse_move[0], @reverse_move[1])
    @board.grid[@reverse_move[0][0]][@reverse_move[0][1]] = @last_captured
    if @queened
      @board[@reverse_move[1]] = Pawn.new(@color, @board, @reverse_move[1])
    end
    if @k_castled
      @has_castled = false
      @board.make_any_move([@curr_pos[0], @curr_pos + 1], [@curr_pos[0], @curr_pos + 3])
    end
  end


end
