require 'byebug'
class Node

  VALUES = {
   Pawn => 1,
   Knight => 3,
   Bishop => 3,
   Rook => 5,
   Queen => 9,
   King => 10000
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

    moves = @board.all_moves_with_start(@color)
    sort_by_captures(moves)

    moves.each do |move|
      save_move(move)
      @board.make_any_move(move[0], move[1])
      new_node = Node.new(@board, @opp_color, @color)
      cur_eval = -1 * new_node.alpha_beta(ply - 1, -beta, -alpha, counter)
      undo_move

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


    piece_eval = evaluate_pieces(pieces) - evaluate_pieces(opp_pieces)
    development_eval = development(pieces, @color) - development(opp_pieces, @opp_color)


    piece_eval + development_eval
  end

  def development(pieces, color)
    val = 0
    if (color == COLORS[0])
      pieces.each do |piece|
        #value pawn advancement different than normal developmenet
        if piece.class == Pawn
          val += 0.005 * (6 - piece.curr_pos[0]).abs
        elsif (!(piece.class == Queen) && !(piece.class == King))
          val += 0.25 if piece.curr_pos[0] < 6
        end
        #king on back rank bonus on crowded board
        if piece.class == King
          val += 0.25 if pieces.length > 9 && piece.curr_pos[0] == 7
        else
          #centralized pieces bonus
          if piece.curr_pos[0] < 6 && piece.curr_pos[1] > 1 && piece.curr_pos[1] < 6
            val += 0.05
          end
        end
      end
    else
      pieces.each do |piece|
        if piece.class == Pawn
          val += 0.005 * (piece.curr_pos[0] - 1)
        elsif (!(piece.class == Queen) && !(piece.class == King))
          val += 0.2 if piece.curr_pos[0] > 1
        end
        if piece.class == King
          val += 0.25 if pieces.length > 9 && piece.curr_pos[0] == 0
        else
          if piece.curr_pos[0] > 1 && piece.curr_pos[1] > 1 && piece.curr_pos[1] < 6
            val += 0.05
          end
        end
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
