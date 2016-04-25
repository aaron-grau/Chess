
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
    best_move = nil
    best_eval = nil
    @alpha = -100000
    @beta = 100000
    pieces = []
    @non_captures = []

    @board.grid.each do |row|
      row.each do |tile|
        pieces << tile if tile.class < Piece && tile.color == @color
      end
    end

    pieces.each do |piece|
      moves = []
      piece_moves = []
      piece_moves = piece.legal_moves(@board)
      piece_moves.each do |target|
        moves << [piece.curr_pos, target]
      end
      captures = sort_by_captures(moves)

      captures.each do |move|
        return_move = test_move(move)
        return return_move unless return_move.nil?
      end

    end

    @non_captures.each do |move|
      return_move = test_move(move)
      return return_move unless return_move.nil?
    end

    @best_move
  end


  def depth
    pieces = 0
    @board.grid.each do |row|
      row.each do |tile|
        pieces += 1 if tile.class < Piece
      end
    end

    depth = 2
    depth = 4 if pieces < 10
    depth = 5 if pieces < 6
    depth = 6 if pieces < 5
    depth = 8 if pieces < 4

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
    @castle = false
    @queened = false
    save_move(move)
    special_move = @board.make_any_move(move[0], move[1])
    @queened = special_move == "queened"
    @k_castled = special_move == "k_castled"
    @q_castled = special_move == "q_castled"
    if @board.is_mate?(@opp_color)
      undo_move
      return move
    end

    cur_node = Node.new(@board, @opp_color, @color)
    cur_eval = -1 * cur_node.alpha_beta(depth, -@beta, -@alpha, 1)
    undo_move

    if cur_eval > @alpha || @best_move.nil?
      @best_move = move
      @alpha = cur_eval
    end

    nil
  end


end
