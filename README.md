# Chess

Play chess against a custom-built Computer AI. This implementation uses Ruby and can be played in the console.

## Instructions

1. Install ruby if you do not already have it.
2. Download the [zip file](https://github.com/RonKew28/Chess/archive/master.zip)
3. Unzip the zip file. In the terminal, navigate to the Chess-master directory.
4. Type 'bundle install' in the console.
5. Type 'ruby game.rb' to start the game!

## How To Play

Learn more about the rules of Chess [here](https://en.wikipedia.org/wiki/Chess).

1. You (the human player) are white, and the computer is black.
2. Using the arrow keys, WASD, or vim, move to the piece you want to select and hit enter.
3. Once you have selected a piece, use the cursor to go to the position you want to move to and press enter.
4. If you did not make a valid move, you will be asked to try again. Otherwise, the AI will make its move.
5. The game is over when one color is put in checkmate.
6. Note: Currently, castling, en passant, and pawn promotion are not supported.


## Computer AI Logic

![ChessAIDemo](chess_AI_demo.gif)

The Computer AI implements a basic set of rules when determining its next move. It looks at each of its possible moves, assigns a value (# of points) to each of these moves, and then chooses the move with the highest value. Each type of piece is given a specific value, with Queens having the highest value and pawns having the lowest value. A separate Move class is used to keep track of the start position, end position, and piece of each of the potential moves. The move class also has an array to hold reasons for implementing the move, which are shown on the screen if that move is selected by the AI.  The AI factors in if any of its pieces are at risk, if it can kill any of its opponents pieces, and if it can put its opponent in check. Below is a code snippet that shows some of the logic the AI uses to determine its next move:

```
computer_pieces.each do |piece|
  points = 0
  piece.valid_moves.each do |potential_move|
    current_move = Move.new(piece.pos, potential_move, piece)
      # update move value based on piece's current position
      update_move_if_at_risk(board, current_move)

      # update move value based on piece's end position in the potential move
      simulated_board = board.dup

      update_move_if_kill_opp_piece(simulated_board, current_move, opponent)

      simulated_board.move_piece!(current_move.start_pos, current_move.end_pos)

      update_move_for_check(current_move, simulated_board, opponent)
      update_move_if_potential_move_at_risk(current_move, simulated_board)
      all_moves << current_move
  end
end

```

## Future Directions

- I would like to refactor my Computer AI logic so that it implements a minimax tree to evaluate its next move. Moreover, I want to
add more logic to the AI so that it looks at more criteria before determining its next move.
- I would also like to implement more complicated moves, such as En Passant and Castling.
