# Chess

Play chess against a custom engine. Built using Ruby and React.js.

[Play here!][live]

[live]: http://agchess.herokuapp.com

## Engine Implementation Details

The AI implements a minimax tree to evaluate its position and find the best move. The premise is that it looks X moves ahead evaluates every resulting position and then follows the moves that lead to the best position it can force, and reevaluates after each response move.  However, because the number of possible positions grows so fast (after just 3 moves by each color there are 9 million possible positions, after 4 there are over 288 billion) it would be impossible to evaluate more than 1 move ahead using a simple min-max algorithm. To overcome this the AI also implements alpha-beta pruning into its minimax algorithm. Alpha-beta pruning allows the AI to stop evaluating branches as soon as it recognizes that it would never have gotten to them because there would have been a better option for either player somewhere higher up the tree. Below is code from the test_move function which tries out an individual move by creating a child node to further evaluate the candidate move:

```
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
```
(full chess logic can be found in the lib/logic directory)

## Front End

- Uses React.js to render board
- Implements React drag and drop module to allow easy piece movement
- Uses AJAX requests to query engine for response moves
- Updates board using Flux cycle

## Screenshot

![image]
[image]: docs/images/chess.png
