class ComputerPlayer

  VALUES = {
           Pawn => 1,
           Knight => 3,
           Bishop => 3,
           Rook => 5,
           Queen => 9
           }

  def initialize(color)
    @color = color
  end

  def play_turn(board)
    @board = board
    pieces = @board.grid.flatten.select do |tile|
      tile.class < Piece && tile.color == @color
    end
    opp_pieces = @board.grid.flatten.select do |tile|
      tile.class < Piece && tile.color != @color
    end
    move = find_capture(pieces, opp_pieces)
    move ||= find_random_move(pieces)

    move
  end

  def find_random_move(pieces)
    piece_to_move = pieces.shuffle.first
    [piece_to_move.curr_pos, piece_to_move.legal_moves(@board).shuffle.first]
  end

  def find_capture(pieces, opp_pieces)
    all_captures = Hash.new { |hash, i| hash[i] = []}
    opp_pieces_pos = opp_pieces.map { |piece| piece.curr_pos }
    pieces.each do |piece|
      moves = piece.legal_moves(@board)
      captures = moves.select { |move| opp_pieces_pos.include?(move) }
      all_captures[piece.curr_pos] = captures unless captures.empty?
    end
    return nil if all_captures.empty?
    captures_pos = []
    all_captures.values.each { |capture_pos| captures_pos += capture_pos }
    end_pos = highest_value(captures_pos)
    start_pos = ""
    all_captures.each do |key, val|
      if val.include?(end_pos)
        start_pos = key
        break
      end
    end

    [start_pos, end_pos]
  end

  def highest_value(pieces_pos)
    piece_value = {}
    pieces = pieces_pos.map { |pos| @board[pos]}
    pieces.each { |piece|  piece_value[piece] = VALUES[piece.class] }

    piece_value.key(piece_value.values.max).curr_pos
  end

end
