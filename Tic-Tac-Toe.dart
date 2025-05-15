import 'dart:io';
void main() {
  TicTacToe game = TicTacToe();
  game.start();
}

class TicTacToe {
  // Board slots represented as a list of strings
  List<String> board = List.filled(9, ' ');
  String currentPlayer = 'X'; 
  bool gameEnded = false; 
  bool AIPlaying = false;
  
  void start() {
    print('\n---TIC-TAC-TOE Game ---\n');
    AIPlaying = _askYesOrNo('Do you want to play againstcomputer?');
    print('\nPlayer 1 will use X and ${AIPlaying ? "Computer" : "Player 2"} will use O');
    // Main game loop
    do {
      resetBoard();
      playGame();
      
      // Ask to play again
      if (!_askYesOrNo('\nDo you want to play again? (y/n)')) {
        print('\nThank you for playing!');
        gameEnded = true;
      }
    } while (!gameEnded);
  }
  
  // Reset the board for a new game
  
  
  // Main game flow
  void playGame() {
    while (!gameEnded) {
      displayBoard();
      
      // Get the next move
      if (AIPlaying && currentPlayer == 'O') {
        makeAIMove();
      } else {
        playerMove();
      }
      
      // Check for win or draw
      if (checkWin()) {
        displayBoard();
        print('\n${currentPlayer} wins!');
        gameEnded = true;
      } else if (isBoardFull()) {
        displayBoard();
        print('\nThe game ended in a draw!');
        gameEnded = true;
      } else {
        // Switch players
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      }
    }
  }
  bool _askYesOrNo(String question) {
    print(question);
    while (true) {
      String? response = stdin.readLineSync()?.toLowerCase();
      if (response == 'y' || response =='yes') {
        return true;
      } else if (response == 'n' || response == 'no') {
        return false;
      } else {
        print('Enter y(yes) or n(no):');
      }
    }
  }
  
  // Display the current state of the board
  void displayBoard() {
    print('\n');
    print(' ${board[0]==' '? '1' :board[0] } | ${board[1]} | ${board[2]} ');
    print('---+---+---');
    print(' ${board[3]} | ${board[4]} | ${board[5]} ');
    print('---+---+---');
    print(' ${board[6]} | ${board[7]} | ${board[8]} ');
    print('\n');
  }
  
  // Handle player move input and validation
  void playerMove() {
    bool validMove = false;
    
    while (!validMove) {
      print('Player $currentPlayer Turn, enter your move (1-9):');
      
      // Show position guide if needed
     
      
      String? input = stdin.readLineSync();
      
      if (input == null || input.isEmpty) {
        print('Please enter a number between 1 and 9.');
        continue;
      }
      
      int? position;
      try {
        position = int.parse(input);
      } catch (e) {
        print('Please enter a valid number.');
        continue;
      }
      
      // Convert to 0-based index and check if valid
      if (position < 1 || position > 9) {
        print('Please enter a number between 1 and 9.');
        continue;
      }
      
      position--; // Convert to 0-based index
      
      if (board[position] != ' ') {
        print('That position is already taken. Try again.');
        continue;
      }
      
      // Valid move
      board[position] = currentPlayer;
      validMove = true;
    }
  }
  void resetBoard() {
    board = List.filled(9, ' ');
    gameEnded = false;
  }
  
  // Simple AI move logic 
  // The Priorities are 
  // 1- choose where Ai will win
  // 2-choose where player will win
  // 3. Center
  // 4. corners
  void makeAIMove() {   
    // Check if AI can win and assigns the move
    int winningMove = findWinningMove('O');
    if (winningMove != -1) {
      board[winningMove] = 'O';
      return;
    }
    
    // Block player if they can win
    int blockingMove = findWinningMove('X');
    if (blockingMove != -1) {
      board[blockingMove] = 'O';
      return;
    }
    
    // Take center if available
    if (board[4] == ' ') {
      board[4] = 'O';
      return;
    }
    
    // Take a corner if available
    List<int> corners = [0, 2, 6, 8];
    corners.shuffle(); // Randomize it make it different everytime
    for (int corner in corners) {
      if (board[corner] == ' ') {
        board[corner] = 'O';
        return;
      }
    }
    
    // Take any available space
    for (int i = 0; i < board.length; i++) {
      if (board[i] == ' ') {
        board[i] = 'O';
        return;
      }
    }
  }
  
  // Find a winning move for the given player marker
  int findWinningMove(String marker) {
    // Check all empty cells to see if placing the marker would result in a win
    for (int i = 0; i < board.length; i++) {
      if (board[i] == ' ') {
        // Try the move
        board[i] = marker;
        
        // Check if it's a winning move
        if (checkWin()) {
          // Undo the move
          board[i] = ' ';
          return i;
        }
        
        // Undo the move
        board[i] = ' ';
      }
    }
    
    return -1; // No winning move found
  }
  
  // Check if the current player has won
  bool checkWin() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (board[i] != ' ' && board[i] == board[i + 1] && board[i] == board[i + 2]) {
        return true;
      }
    }
    
    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[i] != ' ' && board[i] == board[i + 3] && board[i] == board[i + 6]) {
        return true;
      }
    }
    
    // Check diagonals
    if (board[0] != ' ' && board[0] == board[4] && board[0] == board[8]) {
      return true;
    }
    
    if (board[2] != ' ' && board[2] == board[4] && board[2] == board[6]) {
      return true;
    }
    
    return false;
  }
  
  // Check if the board is full (draw condition)
  bool isBoardFull() {
    return !board.contains(' ');
  }
  
  
  
}