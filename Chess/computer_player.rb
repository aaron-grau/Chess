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
    mate = false
    pieces = []

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
      sort_by_captures(moves)
      moves.each do |move|
        save_move(move)
        @board.make_any_move(move[0], move[1])
        mate = true if @board.is_mate?(@opp_color)

        cur_node = Node.new(@board, @opp_color, @color)
        cur_eval = -1 * cur_node.alpha_beta(depth, -beta, -alpha, 1)
        undo_move

        return move if mate

        if cur_eval > alpha
          best_move = move
          alpha = cur_eval
        end
      end
    end

    p "best_eval #{alpha}"
    best_move
  end

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
    moves.each_with_index do |move, idx|
      moves.unshift(moves.delete_at(idx)) if @board[move[1]].class < Piece
    end
  end


end
