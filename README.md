# Chess

Play chess against an engine

## How to play

- Download the repository onto your computer
- Navigate to the file using terminal
- Run the game using command (must have ruby installed locally):
```
  ruby play_game.rb
```
- Depending on your default terminal font size you may have to magnify the terminal to make the board more easily viewable
- Use wasd to navigate around the board, press h or spacebar to select the piece you're hovering over
- Navigate to where you want to move the piece and press h or spacebar again
- The AI will then spend a few seconds thinking and respond to your move

## Technical Details

- The AI implements a minimax tree to evaluate its position and find the best move. The premise is that it looks X moves ahead evaluates every resulting position and then follows the moves that lead to the best position it can force, and reevaluates after each response move.  However, because the number of possible positions grows so fast (after just 3 moves by each color there are 288 million possible positions, after 4 there are over 288 billion) it would be impossible to evaluate more than 1 move ahead using a simple min-max algorithm. To overcome this the AI also implements alpha-beta pruning into its minimax algorithm. Alpha-beta pruning allows the AI to stop evaluating branches as soon as it recognizes that it would never have gotten to them because there would have been a better option for either player somewhere higher up the tree. Below is code from the alpha_beta function:

```
def alpha_beta(ply, alpha, beta, cur_depth, counter)
  counter[:count] += 1
  return evaluate_pos if ply == 0
  no_moves = true

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
      no_moves = false
      save_move(move)
      new_ply = ply - 1
      #do extra plies until 5 depth for lines ending with captures
      new_ply = ply if @board[move[1]].class < Piece && new_ply == 0 && cur_depth < 5
      special_move = @board.make_any_move(move[0], move[1])
      special_save(special_move)
      new_node = Node.new(@board, @opp_color, @color)
      cur_eval = -1 * new_node.alpha_beta(new_ply, -beta, -alpha, cur_depth + 1, counter)
      undo_move

      return beta if cur_eval >= beta

      alpha = cur_eval if cur_eval > alpha

      return alpha if alpha > 1000
    end
  end
  ...

  return alpha;
end
```

## Screenshot

![image]
[image]: /image.png
