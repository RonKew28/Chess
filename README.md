# Chess

Play chess against a custom-built Computer AI.

## Computer AI Logic

The Computer AI implements a basic set of rules when determining its next move. It looks at each of its possible moves, assigns a value (# of points) to each of these moves, and then chooses the move with the highest value. Each type of piece is given a specific value, with Queens having the highest value and pawns having the lowest value. A separate Move class is used to keep track of the start position, end position, and piece of each of the potential moves. The move class also has an array to hold reasons for implementing the move, which are shown on the screen if that move is selected by the AI. Below is a code snippet that shows some of the logic the AI uses to determine its next move:

```
def make_smarter_move(board)
  all_moves = []
  computer_pieces = board.single_color_pieces(self.color)
  computer_pieces.each do |piece|
    points = 0
    priority_move = false
    # want to move pieces that could be captured at their present positions
    piece.valid_moves.each do |potential_move|
      current_move = Move.new(piece.pos, potential_move, piece)
      if could_be_captured?(board, current_move.start_pos)
        priority_move = true
        current_move.reasons << ["piece could be captured at start pos"]
      end

      simulated_board = board.dup

      if !simulated_board.empty?(current_move.end_pos)
        current_move.value += PIECE_VALUES[simulated_board[current_move.end_pos].class]
        current_move.reasons << ["piece can capture opponents piece!"]
      end

      simulated_board.move_piece!(current_move.start_pos, current_move.end_pos)

      if could_be_captured?(simulated_board, current_move.end_pos)
        current_move.reasons << ["piece could be captured at end pos"]
        current_move.value -= PIECE_VALUES[current_move.piece.class]
      end

      if priority_move == true
        current_move.value += PIECE_VALUES[current_move.piece.class]
      end

      all_moves << current_move
    end
  end
```

## Future Directions

- I would like to refactor my Computer AI logic so that it implements a minimax tree to evaluate its next move. Moreover, I want to
add more logic to the AI so that it looks at more criteria before determining its next move.
- I would also like to implement more complicated moves, such as En Passant and Castling.
