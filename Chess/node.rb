require 'byebug'
require 'Benchmark'
class Node

  VALUES = {
   Pawn => 1,
   Knight => 3,
   Bishop => 3,
   Rook => 5,
   Queen => 9,
   King => 10000
  }

  DEVELOPMENT = {
    pawn_push: 0.005,
    piece_out: 0.25,
    queen_out: 0.1,
    king_back: 0.25,
    centralized: 0.05
  }

  COLORS = ["white", "black"]
  def initialize(board, color, opp_color)
    @board = board
    @color = color
    @opp_color = opp_color
  end


  def alpha_beta(ply, alpha, beta, cur_depth, counter)
    counter[:count] += 1
    return evaluate_pos if ply == 0


    pieces = []

    @board.grid.each do |row|
      row.each do |tile|
        pieces << tile if tile.class < Piece && tile.color == @color
      end
    end

    @non_captures = []

    pieces.each do |piece|
      moves = []
      piece_moves = []
      piece_moves = piece.moves(@board)
      piece_moves.each do |target|
        moves << [piece.curr_pos, target]
      end
      captures = sort_by_captures(moves)
      captures.each do |move|
        save_move(move)
        new_ply = ply - 1
        #do extra plies until 5 depth for lines ending with captures
        new_ply = ply if @board[move[1]].class < Piece && new_ply == 0 && cur_depth < 5
        @board.make_any_move(move[0], move[1])
        new_node = Node.new(@board, @opp_color, @color)
        cur_eval = -1 * new_node.alpha_beta(new_ply, -beta, -alpha, cur_depth + 1, counter)
        undo_move

        return beta if cur_eval >= beta

        alpha = cur_eval if cur_eval > alpha
      end
    end

    @non_captures.each do |move|
      save_move(move)
      new_ply = ply - 1
      #do extra plies until 5 depth for lines ending with captures
      new_ply = ply if @board[move[1]].class < Piece && new_ply == 0 && cur_depth < 6
      @board.make_any_move(move[0], move[1])
      new_node = Node.new(@board, @opp_color, @color)
      cur_eval = -1 * new_node.alpha_beta(new_ply, -beta, -alpha, cur_depth + 1, counter)
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
          val += DEVELOPMENT[:pawn_push] * (6 - piece.curr_pos[0]).abs
        elsif !(piece.class == Queen) && !(piece.class == King)
          val += DEVELOPMENT[:piece_out] if piece.curr_pos[0] < 6
        elsif piece.class == Queen
          val += DEVELOPMENT[:queen_out]
        end
        #king on back rank bonus on crowded board
        if piece.class == King
          val += DEVELOPMENT[:king_back] if pieces.length > 9 && piece.curr_pos[0] == 7
        elsif piece.curr_pos[0] < 6 && piece.curr_pos[1] > 1 && piece.curr_pos[1] < 6
          #centralized pieces bonus
          val += DEVELOPMENT[:centralized]
        end
      end
    else
      pieces.each do |piece|
        if piece.class == Pawn
          val += DEVELOPMENT[:pawn_push] * (piece.curr_pos[0] - 1)
        elsif (!(piece.class == Queen) && !(piece.class == King))
          val += DEVELOPMENT[:piece_out] if piece.curr_pos[0] > 1
        elsif piece.class == Queen
          val += DEVELOPMENT[:queen_out]
        end
        if piece.class == King
          val += DEVELOPMENT[:king_back] if pieces.length > 9 && piece.curr_pos[0] == 0
        elsif piece.curr_pos[0] < 6 && piece.curr_pos[1] > 1 && piece.curr_pos[1] < 6
          val += DEVELOPMENT[:centralized]
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


end
