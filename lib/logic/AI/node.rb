class Node
  include UndoMove

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
    @board, @color, @opp_color = board, color, opp_color
  end


  def alpha_beta(ply, alpha, beta, cur_depth)
    @alpha, @beta, @ply, @cur_depth, @no_moves = alpha, beta, ply, cur_depth, true
    #reached end of set tree search evaluate and return
    return evaluate_pos if @ply == 0

    pieces = get_pieces
    return 0 if pieces.length < 4 && @board.stalemate?(@color)

    @non_captures = []
    #search captures first more likely for alpha spikes allowing for early returns

    return_early = test_moves(pieces)
    return return_early unless return_early.nil?

    return_early = test_non_captures
    return return_early unless return_early.nil?

    #if no moves exist evaluate and return
    return evaluate_pos if @no_moves

    @alpha
  end

  private

  def test_non_captures
    @non_captures.each do |move|
      cur_eval = test_move(move)
      return_early = alpha_beta_checker(cur_eval)
      return return_early unless return_early.nil?
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
        cur_eval = test_move(move, true)
        return_early = alpha_beta_checker(cur_eval)
        return return_early unless return_early.nil?
      end
    end

    nil
  end

  def get_pieces
    @board.grid.flatten.select do |tile|
      tile.class < Piece && tile.color == @color
    end
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

    piece_eval + development_eval + check_penalty(opp_pieces, pieces)
  end

  def check_penalty(opp_pieces, pieces)
    val = 0
    val = -1 if pieces.length < 5 && @board.in_check?(@color)

    val
  end

  def development(pieces, color)
    color == COLORS[0] ? white_dev(pieces) : black_dev(pieces)
  end

  def white_dev(pieces)
    val = 0
    pieces.each do |piece|
      #value pawn advancement different than normal developmenet
      if piece.class == Pawn
        val += 0.005 * (6 - piece.curr_pos[0]).abs
        val += 0.2 if piece.curr_pos[0] == 1 || piece.curr_pos[0] == 2
      elsif piece.class == Knight || piece.class == Bishop
        val += 0.25 if piece.curr_pos[0] < 6
      elsif piece.class == Queen
        val += 0.1 if piece.curr_pos[0] < 6
      end
      #king on back rank bonus on crowded board
      if piece.class == King
        val += 0.5 if pieces.length > 9 && piece.curr_pos[0] == 7
        #pawn in front of castled king bonus
        if piece.has_castled && piece.curr_pos[0] == 7
          val += 0.75
          if @board[[piece.curr_pos[0] - 1, piece.curr_pos[1]]].class == Pawn &&
             @board[[piece.curr_pos[0] - 1, piece.curr_pos[1]]].color == COLORS[0]
            val += 1
          end
          if @board[[piece.curr_pos[0] - 2, piece.curr_pos[1]]].class == Pawn &&
             @board[[piece.curr_pos[0] - 2, piece.curr_pos[1]]].color == COLORS[0]
            val += 0.75
          end
        end
      else
        #centralized pieces bonus
        if piece.curr_pos[0] < 6 && piece.curr_pos[1] > 1 && piece.curr_pos[1] < 6
          val += 0.05
        end
      end
    end

    val
  end

  def black_dev(pieces)
    val = 0
    pieces.each do |piece|
      if piece.class == Pawn
        val += 0.005 * (piece.curr_pos[0] - 1)
        val += 0.2 if piece.curr_pos[0] == 6 || piece.curr_pos[0] == 5
      elsif piece.class == Knight || piece.class == Bishop
        val += 0.2 if piece.curr_pos[0] > 1
      elsif piece.class == Queen
        val += 0.1 if piece.curr_pos[0] > 1
      end
      if piece.class == King
        val += 0.5 if pieces.length > 9 && piece.curr_pos[0] == 0
        if piece.has_castled && piece.curr_pos[0] == 0
          val += 0.75
          if @board[[piece.curr_pos[0] + 1, piece.curr_pos[1]]].class == Pawn &&
             @board[[piece.curr_pos[0] + 1, piece.curr_pos[1]]].color == COLORS[1]
            val += 1
          end
          if @board[[piece.curr_pos[0] + 2, piece.curr_pos[1]]].class == Pawn &&
             @board[[piece.curr_pos[0] + 2, piece.curr_pos[1]]].color == COLORS[1]
            val += 0.75
          end
        end
      else
        if piece.curr_pos[0] > 1 && piece.curr_pos[1] > 1 && piece.curr_pos[1] < 6
          val += 0.05
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

  def special_save(special_move)
    @castle = false
    @queened = false
    @queened = special_move == "queened"
    @k_castled = special_move == "k_castled"
    @q_castled = special_move == "q_castled"
  end

  def test_move(move, capture = false)
    @no_moves, @k_castled, @q_castled, @queened = false, false, false, false

    #make move, get eval from child node, undo move
    save_move(move)
    check_special_move(@board.make_any_move(move[0], move[1]))
    new_node = Node.new(@board, @opp_color, @color)
    new_eval = -1 * new_node.alpha_beta(new_ply(capture), -@beta, -@alpha, @cur_depth + 1)
    undo_move

    new_eval
  end

  def check_special_move(special_move)
    @queened = special_move == "queened"
    @k_castled = special_move == "k_castled"
    @q_castled = special_move == "q_castled"
  end

  def new_ply(capture)
    new_ply = @ply - 1
    new_ply = 1 if capture && new_ply == 0 && @cur_depth < 4

    new_ply
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

  def alpha_beta_checker(cur_eval)
    return @beta if cur_eval >= @beta
    @alpha = cur_eval if cur_eval > @alpha
    return @alpha if @alpha > 1000

    nil
  end


end
