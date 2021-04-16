import 'dart:math';
import 'package:collection/collection.dart';
class Solver {



  bool checkBoard(board){
    for(int row = 0; row<9; row++){
      for(int col = 0; col < 9; col ++){
        if(board[row][col] == ""){
          return false;
        }
      }
    }
    return true;
  }
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

  bool fillBoard(board){
    List<int> numberList = [1,2,3,4,5,6,7,8,9];
    for(int row = 0; row < 9; row++){
      for(int col = 0; col < 9; col++){
        if(board[row][col] == ""){
          numberList.shuffle();
          for(int i = 0; i < numberList.length; i++){
            if(isValid(board, row, col, numberList[i])){
              board[row][col] = numberList[i];
              if(fillBoard(board)){
                return true;
              } else {
                board[row][col] = "";
              }
          }}
          return false;
        }
      }
    }
    return true;
  }

  List<List<dynamic>> boardFiller(board){
    fillBoard(board);
    return board;
  }

  bool solve(board) {
    List<int> numberList = [1,2,3,4,5,6,7,8,9];
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (board[r][c] == "") {
          numberList.shuffle();
          for(int i = 0; i < numberList.length; i++){
            if(isValid(board, r, c, numberList[i])){
              board[r][c] = numberList[i];
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

  dynamic createBoard(board){
    List<List<dynamic>> tempBoard = [];
    for(int row =0; row < 9; row++){
      tempBoard.add([]);
      for(int col = 0; col < 9; col++){
        tempBoard[row].add(board[row][col]);
      }
    }
    return tempBoard;
  }
}












