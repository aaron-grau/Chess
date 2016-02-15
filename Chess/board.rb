require_relative "display"
require_relative 'sliding_piece'
require_relative 'stepping_piece'
require_relative 'piece'
require_relative 'bishop'
require_relative 'king'
require_relative 'knight'
require_relative 'queen'
require_relative 'rook'
require_relative 'pawn'
require 'colorize'
require 'byebug'
class Board

  attr_reader :grid

  BLACK_PIECES = [
    Rook.new("black", self, [0,0]),
    Knight.new("black", self, [0,1]),
    Bishop.new("black", self, [0,2]),
    King.new("black", self, [0,3]),
    Queen.new("black", self, [0,4]),
    Bishop.new("black", self, [0,5]),
    Knight.new("black", self, [0,6]),
    Rook.new("black", self, [0,7])
  ]
  WHITE_PIECES = [
    Rook.new(self, [7,0]),
    Knight.new(self, [7,1]),
    Bishop.new(self, [7,2]),
    King.new(self, [7,3]),
    Queen.new(self, [7,4]),
    Bishop.new(self, [7,5]),
    Knight.new(self, [7,6]),
    Rook.new(self, [7,7])
  ]

  def initialize
    @grid = Array.new(8){Array.new(8){" "}}
    set_board
    @grid[2][2] = Knight.new(self, [2,2])
    @grid[2][4] = Knight.new(self, [2,4])
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @grid[row][col] = val
  end

  def set_board
    @grid.each_index do |idx|
      if idx == 0
        @grid[idx] = BLACK_PIECES
      end
      if idx == 7
        @grid[idx] = WHITE_PIECES
      end
      if idx == 1
        @grid[idx].each_index do |idx2|
          @grid[idx][idx2] = Pawn.new("black", self, [idx,idx2])
        end
      elsif idx == 6
        @grid[idx].each_index do |idx2|
          @grid[idx][idx2] = Pawn.new(self, [idx,idx2])
        end
      end
    end
  end

  def move(start,end_pos)
    start_row, start_col = start
    end_row, end_col = end_pos
    start_piece = @grid[start_row][start_col]
    raise IllegalMoveError("This is an illegal move!") unless legal_move?

    @grid[end_row][end_col] = start_piece
    start_piece = nil

  end

  def legal_move?(start, end_pos)
    return false if start.nil?
  end

  def legal_moves(color)
    legal_moves = []
    pieces =
      @grid.flatten.select do |tile|
        tile.class < Piece && tile.color == color
      end
    debugger
    pieces.each do |piece|
      moves = piece.moves(self)
      moves.each do |move|
        cur_row, cur_col = piece.curr_pos[0], piece.curr_pos[1]
        new_move_row, new_move_col = move[0], move[1]
        prev_val = @grid[new_move_row][new_move_col] # should call dup 
        @grid[new_move_row][new_move_col] = piece
        @grid[cur_row][cur_col] = " "
        legal_moves << move unless in_check?(color)
        @grid[cur_row][cur_col] = piece
        @grid[new_move_row][new_move_col] = " "
      end
    end
    debugger
    legal_moves
  end

  def is_mate?(color)
    legal_moves(color).empty?
  end

  def in_bounds?(pos)
    pos.all?{|el| el >= 0 && el <= 7}
  end

  def is_empty?(pos)
    row, col = pos
    @grid[row][col] == " " || !in_bounds?(pos)
  end

  def in_check?(color)
    king_pos = []
    @grid.flatten.each do |tile|
      if tile.is_a?(King) && tile.color == color
        king_pos = tile.curr_pos
      end
    end
    opp_pieces =
      @grid.flatten.select do |tile|
        tile.class < Piece && tile.color != color
      end
      #debugger
    opp_pieces.any? do |piece|
      piece.moves(self).include?(king_pos)
    end

  end
end



board = Board.new()
display = Display.new(board)
#display.navigate
p board.in_check?("black")
p board.in_check?("white")
p board.is_mate?("black")
p board.is_mate?("white")
#display.navigate
# pawn = Pawn.new('black', board, [4,4])
# pawn.has_moved = true
# p pawn.moves(board)
