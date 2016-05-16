
class ComputerPlayer
  include UndoMove

  COLORS = ["white", "black"]

  def initialize(color)
    @color = color
    @opp_color = @color == COLORS[0] ? "black" : "white"
  end

  def play_turn(board)
    @board = board
    find_best_move
  end


  private

  def find_best_move
    @best_move, @best_eval, @alpha, @beta = nil, nil, -100000, 100000
    pieces = get_pieces
    @non_captures = []
    #search captures first more likely for alpha spikes allowing for early returns
    return_mate = test_moves(pieces)
    return return_mate unless return_mate.nil?

    return_mate = test_non_captures
    return return_mate unless return_mate.nil?

    @best_move
  end

  def test_non_captures
    @non_captures.each do |move|
      cur_eval = test_move(move)
      return cur_eval if @mate_found
      alpha_beta_checker(cur_eval, move)
    end

    nil
  end

  def test_moves(pieces)
    pieces.each do |piece|
      moves = []
      piece_moves = []
      piece_moves = piece.moves(@board)
      piece_moves.each do |target|
        moves << [piece.curr_pos, target]
      end
      captures = sort_by_captures(moves)
      captures.each do |move|
        cur_eval = test_move(move)
        return cur_eval if @mate_found
        alpha_beta_checker(cur_eval, move)
      end
    end

    nil
  end


  def get_pieces
    @board.grid.flatten.select do |tile|
      tile.class < Piece && tile.color == @color
    end
  end



  def depth
    pieces = 0
    @board.grid.each do |row|
      row.each do |tile|
        pieces += 1 if tile.class < Piece
      end
    end

    depth = 2
    depth = 3 if pieces < 10
    depth = 4 if pieces < 5

    depth
  end

  def sort_by_captures(moves)
    captures = []
    non_captures = []

    moves.each_with_index do |move, idx|
      if @board[move[1]].class < Piece
        captures << move
      else
        @non_captures << move
      end
    end

    captures
  end

  def test_move(move)
    @mate_found, @k_castled, @q_castled, @queened = false, false, false, false
    #make move, get eval from child node, undo move
    save_move(move)
    check_special_move(@board.make_any_move(move[0], move[1]))
    #if mate stop and return mate
    if @board.is_mate?(@opp_color)
      undo_move
      @mate_found = true
      return move
    end
    cur_node = Node.new(@board, @opp_color, @color)
    new_eval = -1 * cur_node.alpha_beta(depth, -@beta, -@alpha, 1)
    undo_move

    new_eval
  end

  def check_special_move(special_move)
    @queened = special_move == "queened"
    @k_castled = special_move == "k_castled"
    @q_castled = special_move == "q_castled"
  end

  def alpha_beta_checker(cur_eval, move)
    if cur_eval > @alpha
      @alpha = cur_eval
      @best_move = move
    end
  end


end
