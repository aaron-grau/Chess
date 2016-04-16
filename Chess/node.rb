class Node

  VALUES = {
   Pawn => 1,
   Knight => 3,
   Bishop => 3,
   Rook => 5,
   Queen => 9,
   King => 100 #just filler so computation doesnt crash king can never be captutred would hit mate first
  }

  COLORS = ["white", "black"]
  def initialize(board, color, opp_color)
    @board = board
    @color = color
    @opp_color = opp_color
  end


  def alpha_beta(ply, alpha, beta, counter = {count: 0})
    return evaluate_pos if ply == 0
    #dont check for mate unless position is check to avoid more expensive comp
    return -1000 if @board.in_check?(@color) && @board.is_mate?(@color)


    legalMoves = @board.legal_moves_with_start(@color)
    sort_by_captures(legalMoves)

    legalMoves.each do |move|
      save_move(move)
      @board.make_any_move(move[0], move[1])
      new_node = Node.new(@board, @opp_color, @color)
      cur_eval = -1 * new_node.alpha_beta(ply - 1, -beta, -alpha, counter)
      undo_move

      #found mate stop searching this line for something better
      return cur_eval if cur_eval == 1000

      return beta if cur_eval >= beta

      alpha = cur_eval if cur_eval > alpha

    end

    return alpha;
  end

  private

  def save_move(move)
    start, end_pos = move
    end_row, end_col = end_pos
    @last_captured = @board.grid[end_row][end_col]
    @reverse_move  = [end_pos, start]
  end

  def undo_move
    @board.make_any_move(@reverse_move[0], @reverse_move[1])
    @board.grid[@reverse_move[0][0]][@reverse_move[0][1]] = @last_captured
  end

  def evaluate_pos

    pieces = []
    @board.grid.each do |row|
      row.each do |square|
        pieces << square if square != " " && square.color == @color
      end
    end

    opp_pieces = []
    @board.grid.each do |row|
      row.each do |square|
        opp_pieces << square if square != " " && square.color == @opp_color
      end
    end


    (evaluate_pieces(pieces) - evaluate_pieces(opp_pieces)) + development(pieces)
  end

  def development(pieces)
    val = 0
    if (@color == COLORS[0])
      pieces.each do |piece|
        val += 0.01 if piece.curr_pos[0] < 6
      end
    else
      pieces.each do |piece|
        val += 0.01 if piece.curr_pos[0] > 1
      end
    end

    val
  end

  def evaluate_pieces(pieces)
    total = 0

    pieces.each do |piece|
      total += VALUES[piece.class]
    end

    total
  end

  def sort_by_captures(moves)
    moves.each_with_index do |move, idx|
      moves.unshift(moves.delete_at(idx)) if @board[move[1]].class < Piece
    end
  end


end
