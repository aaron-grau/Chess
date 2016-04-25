# Chess

Play chess against a custom engine. Built using Ruby and React.js.

[Play the here!][live]

[live]: http://agchess.herokuapp.com

## Engine Implementation Details

The AI implements a minimax tree to evaluate its position and find the best move. The premise is that it looks X moves ahead evaluates every resulting position and then follows the moves that lead to the best position it can force, and reevaluates after each response move.  However, because the number of possible positions grows so fast (after just 3 moves by each color there are 9 million possible positions, after 4 there are over 288 billion) it would be impossible to evaluate more than 1 move ahead using a simple min-max algorithm. To overcome this the AI also implements alpha-beta pruning into its minimax algorithm. Alpha-beta pruning allows the AI to stop evaluating branches as soon as it recognizes that it would never have gotten to them because there would have been a better option for either player somewhere higher up the tree. Below is code from the test_move function which tries out an individual move by creating a child node to further evaluate the candidate move:

```
def test_move(move, capture = false)
  @no_moves = false
  @castle = false
  @queened = false
  save_move(move)
  special_move = @board.make_any_move(move[0], move[1])
  #check to see if a 'special move' has occurred so it can be undone on way up tree
  @queened = special_move == "queened"
  @k_castled = special_move == "k_castled"
  @q_castled = special_move == "q_castled"

  new_ply = @ply - 1
  #go deeper if line ends with capture
  new_ply += 1 if capture && @cur_depth < 5 && new_ply == 0
  #make a new node
  cur_node = Node.new(@board, @opp_color, @color)
  cur_eval = -1 * cur_node.alpha_beta(new_ply, -@beta, -@alpha, @cur_depth + 1, @counter)
  undo_move

  #set alpha and best move to the current move if its better than previously found best move
  if cur_eval > @alpha || @best_move.nil?
    @best_move = move
    @alpha = cur_eval
  end

  cur_eval
end
```

## Front End

- Uses React.js to render board
- Implements React drag and drop module to allow easy piece movement
- Uses AJAX requests to query engine for response moves
- Updates board using Flux cycle

## Screenshot

![image]
[image]: docs/images/chess.png
