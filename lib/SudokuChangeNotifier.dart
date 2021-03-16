import 'package:flutter/cupertino.dart';
import 'package:sudoku/Solver.dart';

class SudokuChangeNotifier with ChangeNotifier {
  final solver = Solver();
  List<List<dynamic>> board = [
    ["", "", "", "", 4, "", 6, "", ""],
    ["", "", "", "", 9, 3, 8, "", 2],
    ["", 7, 3, "", 2, "", 1, "", 4],
    [1, "", 5, 4, 3, "", "", "", ""],
    ["", 2, "", "", "", "", "", 4, ""],
    ["", "", 6, "", 1, "", "", "", 7],
    ["", 4, "", 5, "", "", 7, "", ""],
    ["", 5, "", "", "", 1, "", "", ""],
    [9, "", 2, "", 7, 4, "", "", ""],
  ];

  void solveBoard() {
    List<List<dynamic>> solvedBoard = solver.solveSudoku(this.board);
    debugPrint("the board was solved");
    debugPrint(solvedBoard.toString());
    notifyListeners();
  }

  String getBoardCell(int row, int col) {
    return this.board[row][col] == "" ? "" : this.board[row][col].toString();
  }

  void setBoardCell(int row, int col) {
    this.board[row][col] = this.board[row][col];
    notifyListeners();
  }
}
