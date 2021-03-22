class Solver {
  

  bool isValid(board, r, c, d) {
    for (int row = 0; row < 9; row++) {
      if (board[row][c] == d) {
        return false;
      }
    }
    for (int col = 0; col < 9; col++) {
      if (board[r][col] == d) {
        return false;
      }
    }
    for (int row = (r ~/ 3) * 3; row < (r ~/ 3 + 1) * 3; row++) {
      for (int col = (c ~/ 3) * 3; col < (c ~/ 3 + 1) * 3; col++) {
        if (board[row][col] == d) {
          return false;
        }
      }
    }
    return true;
  }

  bool solve(board) {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (board[r][c] == "") {
          for (int d = 1; d < 10; d++) {
            if (isValid(board, r, c, d)) {
              board[r][c] = d;
              if (solve(board)) {
                return true;
              } else {
                board[r][c] = "";
              }
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  List<List<dynamic>> solveSudoku(board) {
    solve(board);
    return board;
  }
}


  

