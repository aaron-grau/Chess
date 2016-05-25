class Node
  include UndoMove
  attr_accessor :color, :opp_color, :board, :best_eval, :alpha, :beta, :cur_depth,
  :non_captures, :mate_found, :k_castled, :q_castled, :queened, :ply, :no_moves,
  :moved_piece, :last_captured, :reverse_move, :disabled_castling

  def initialize(board, color, opp_color)
    @board, @color, @opp_color = board, color, opp_color
  end


  def alpha_beta(ply, alpha, beta, cur_depth)
    @alpha, @beta, @ply, @cur_depth, @no_moves = alpha, beta, ply, cur_depth, true
    #reached end of set tree search evaluate and return
    return evaluate_pos if ply == 0

    pieces = get_pieces
    return 0 if pieces.length < 4 && board.stalemate?(color)

    @non_captures = []
    #search captures first more likely for alpha spikes allowing for early returns
    return_early = test_captures(pieces)
    return return_early unless return_early.nil?

    return_early = test_non_captures
    return return_early unless return_early.nil?

    #if no moves exist evaluate and return
    return evaluate_pos if no_moves

    self.alpha
  end

  private

  def test_non_captures
    non_captures.each do |move|
      cur_eval = test_move(move)
      return_early = alpha_beta_checker(cur_eval)
      return return_early unless return_early.nil?
    end

    nil
  end

  def test_captures(pieces)
    pieces.each do |piece|
      moves = get_moves(piece)
      captures = sort_by_captures(moves)
      captures.each do |move|
        cur_eval = test_move(move, true)
        return_early = alpha_beta_checker(cur_eval)
        return return_early unless return_early.nil?
      end
    end

    nil
  end

  def get_moves(piece)
    piece_moves = piece.moves(board)
    piece_moves.map do |target|
      [piece.curr_pos, target]
    end
  end

  def get_pieces
    board.get_pieces(color)
  end

  def get_opp_pieces
    board.get_pieces(opp_color)
  end

  def evaluate_pos
    pieces = get_pieces
    opp_pieces = get_opp_pieces

    piece_eval = evaluate_pieces(pieces) - evaluate_pieces(opp_pieces)
    development_eval = development(pieces, color) - development(opp_pieces, opp_color)

    piece_eval + development_eval + check_penalty(opp_pieces, pieces)
  end

  def check_penalty(opp_pieces, pieces)
    val = 0
    val = -1 if opp_pieces.length < 5 && board.in_check?(color)

    val
  end

  def development(pieces, color)
    color == COLORS[0] ? white_dev(pieces) : black_dev(pieces)
  end

  def white_dev(pieces)
    val = 0
    pieces.each do |piece|
      val += w_piece_dev(piece)
      #king on back rank bonus on crowded board
      if piece.class == King
        val += w_king_safety(piece, pieces)
      else
        val += w_piece_centralized(piece)
      end
    end
    val
  end

  def w_piece_centralized(piece)
    val = 0
    if piece.curr_pos[0] < 6 && piece.curr_pos[1] > 1 && piece.curr_pos[1] < 6
      val = 0.05
    end

    val
  end

  def w_piece_dev(piece)
    val = 0
    if piece.class == Pawn
      val += w_pawn_dev(piece)
    elsif piece.class == Knight || piece.class == Bishop
      val += 0.25 if piece.curr_pos[0] < 6
    elsif piece.class == Queen
      val += 0.1 if piece.curr_pos[0] < 6
    end

    val
  end

  def w_pawn_dev(pawn)
    val = 0
    val += 0.005 * (6 - pawn.curr_pos[0]).abs
    val += 0.2 if pawn.curr_pos[0] == 1 || pawn.curr_pos[0] == 2

    val
  end

  def w_king_safety(piece, pieces)
    val = 0
    val += 0.5 if pieces.length > 9 && piece.curr_pos[0] == 7
    #pawn in front of castled king bonus
    if piece.has_castled && piece.curr_pos[0] == 7
      val += 0.75
      if board[[piece.curr_pos[0] - 1, piece.curr_pos[1]]].class == Pawn &&
         board[[piece.curr_pos[0] - 1, piece.curr_pos[1]]].color == COLORS[0]
        val += 1
      end
      if board[[piece.curr_pos[0] - 2, piece.curr_pos[1]]].class == Pawn &&
         board[[piece.curr_pos[0] - 2, piece.curr_pos[1]]].color == COLORS[0]
        val += 0.75
      end
    end

    val
  end

  def black_dev(pieces)
    val = 0
    pieces.each do |piece|
      val += b_piece_dev(piece)
      #king on back rank bonus on crowded board
      if piece.class == King
        val += b_king_safety(piece, pieces)
      else
        val += b_piece_centralized(piece)
      end
    end

    val
  end

  def b_piece_centralized(piece)
    val = 0
    if piece.curr_pos[0] > 1 && piece.curr_pos[1] > 1 && piece.curr_pos[1] < 6
      val += 0.05
    end

    val
  end

  def b_piece_dev(piece)
    val = 0
    if piece.class == Pawn
      val += b_pawn_dev(piece)
    elsif piece.class == Knight || piece.class == Bishop
      val += 0.25 if piece.curr_pos[0] > 1
    elsif piece.class == Queen
      val += 0.1 if piece.curr_pos[0] > 1
    end

    val
  end

  def b_pawn_dev(pawn)
    val = 0
    val += 0.005 * (pawn.curr_pos[0] - 1)
    val += 0.2 if pawn.curr_pos[0] == 6 || pawn.curr_pos[0] == 5

    val
  end

  def b_king_safety(piece, pieces)
    val = 0
    val += 0.5 if pieces.length > 9 && piece.curr_pos[0] == 0
    if piece.has_castled && piece.curr_pos[0] == 0
      val += 0.75
      if board[[piece.curr_pos[0] + 1, piece.curr_pos[1]]].class == Pawn &&
         board[[piece.curr_pos[0] + 1, piece.curr_pos[1]]].color == COLORS[1]
        val += 1
      end
      if board[[piece.curr_pos[0] + 2, piece.curr_pos[1]]].class == Pawn &&
         board[[piece.curr_pos[0] + 2, piece.curr_pos[1]]].color == COLORS[1]
        val += 0.75
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

  def test_move(move, capture = false)
    @no_moves, @k_castled, @q_castled, @queened = false, false, false, false

    #make move, get eval from child node, undo move
    save_move(move)
    check_special_move(board.make_any_move(move[0], move[1]))
    new_node = Node.new(board, opp_color, color)
    new_eval = -1 * new_node.alpha_beta(new_ply(capture), -beta, -alpha, cur_depth + 1)
    undo_move

    new_eval
  end

  def new_ply(capture)
    new_ply = ply - 1
    new_ply = 1 if capture && new_ply == 0 && cur_depth < 4

    new_ply
  end

  def sort_by_captures(moves)
    captures = []

    moves.each_with_index do |move, idx|
      if board[move[1]].class < Piece
        captures << move
      else
        non_captures << move
      end
    end

    captures
  end

  def alpha_beta_checker(cur_eval)
    return beta if cur_eval >= beta
    @alpha = cur_eval if cur_eval > alpha
    return alpha if alpha > 1000

    nil
  end


end
