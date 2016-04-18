require 'benchmark'

class ComputerPlayer

  COLORS = ["white", "black"]

  def initialize(color)
    @color = color
    @opp_color = @color == COLORS[0] ? "black" : "white"
  end

  def play_turn(board)
    @board = board

    puts Benchmark.measure { @move = find_best_move }

    @move
  end


  private

  def find_best_move
    best_move = nil
    best_eval = nil
    alpha = -100000
    beta = 100000
    pieces = []
    counter = {count: 0}
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
        cur_eval = -1 * cur_node.alpha_beta(depth, -beta, -alpha, 1, counter)
        undo_move

        if cur_eval > alpha
          best_move = move
          alpha = cur_eval
        end

      end
    end

    @non_captures.each do |move|
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
      new_node = Node.new(@board, @opp_color, @color)
      cur_eval = -1 * new_node.alpha_beta(depth, -beta, -alpha, 1, counter)
      undo_move


      return beta if cur_eval >= beta

      if cur_eval > alpha
        best_move = move
        alpha = cur_eval
      end
    end

    p "total nodes visited #{counter}"
    p "best_eval #{alpha}"
    best_move
  end

  def save_move(move)
    @disabled_castling = false
    start, end_pos = move
    end_row, end_col = end_pos
    @last_captured = @board.grid[end_row][end_col]
    @reverse_move  = [end_pos, start]
    @disabled_castling = true if @board[start].can_castle
  end

  def undo_move
    @board.make_any_move(@reverse_move[0], @reverse_move[1])
    @board.grid[@reverse_move[0][0]][@reverse_move[0][1]] = @last_captured
    curr_pos = [@reverse_move[1][0], @reverse_move[1][1]]
    if @queened
      @board[@reverse_move[1]] = Pawn.new(@color, @board, @reverse_move[1])
    end
    if @k_castled
      @board.make_any_move([curr_pos[0], curr_pos[1] + 1], [curr_pos[0], curr_pos[1] + 3])
      @board[[curr_pos[0], curr_pos[1] + 3]].can_castle = true
      @board[@reverse_move[1]].has_castled = false
    end
    if @q_castled
      @board.make_any_move([curr_pos[0], curr_pos[1] - 1], [curr_pos[0], curr_pos[1] - 4])
      @board[[curr_pos[0], curr_pos[1] - 4]].can_castle = true
      @board[@reverse_move[1]].has_castled = false
    end
    @board[@reverse_move[1]].can_castle = true if @disabled_castling
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
    depth = 6 if pieces < 6
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


end
