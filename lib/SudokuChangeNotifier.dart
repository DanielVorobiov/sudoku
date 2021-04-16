import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/Solver.dart';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter_restart/flutter_restart.dart';

class SudokuChangeNotifier with ChangeNotifier {

  List<List<dynamic>> board = [
    ["", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", ""],
    ["", "", "", "", "", "", "", "", ""],
  ];

  final solver = Solver();
  List<List<dynamic>>  eliminator(board){

    final random = new Random();
    solver.fillBoard(board);
    //print(board);
    int emptyCells = 15;
    while(emptyCells > 0){
      int r = random.nextInt(9);
      int c = random.nextInt(9);
      if(board[r][c] == ""){
        int r = random.nextInt(9);
        int c = random.nextInt(9);
        board[r][c] = "";
        emptyCells -=1;
      }  else {
        board[r][c] = "";
        emptyCells -=1;
      }

    }

    List<List<List<dynamic>>> solutions = [];
    List<List<dynamic>> temp1 = solver.createBoard(board);
    temp1 = solver.solveSudoku(temp1);
    solutions.add(temp1);
    int attempts = 10;

    while(attempts > 0) {
      List<List<dynamic>> temp2 = solver.createBoard(board);

      temp2 = solver.solveSudoku(temp2);
      for (int element = 0; element < solutions.length ; element++) {
        if (DeepCollectionEquality().equals(solutions[element], temp2) == false) {
          solutions.add(temp2);
        } }
      attempts -= 1;
      if(solutions.length > 1){
        break;
      }
    }

    return temp1;
  }

  void solveBoard() {
    List<List<dynamic>> newBoard = eliminator(board);

    notifyListeners();

  }

  String getBoardCell(int row, int col) {

    return this.board[row][col] == "" ? "" : this.board[row][col].toString();
  }

  
}
