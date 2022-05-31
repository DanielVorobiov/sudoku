import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:sudoku/consts.dart';
import 'package:sudoku/logic/Solver.dart';
import 'package:sudoku/screens/themes.dart';
import 'package:flutter/foundation.dart';

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
  List<List<dynamic>> untouchables = [];
  List<List<List<dynamic>>> solutions = [];
  bool complete = false;

  dynamic selectedNumber = 0;
  final solver = Solver();

  List<List<dynamic>> eliminator(board) {
    final random = new Random();
    solver.fillBoard(board);
    int emptyCells = 20;
    while (emptyCells > 0) {
      int r = random.nextInt(9);
      int c = random.nextInt(9);
      if (board[r][c] == "") {
        int r = random.nextInt(9);
        int c = random.nextInt(9);
        board[r][c] = "";
        emptyCells -= 1;
      } else {
        board[r][c] = "";
        emptyCells -= 1;
      }
    }

    solutions = [];
    List<List<dynamic>> temp1 = solver.createBoard(board);
    temp1 = solver.solveSudoku(temp1);
    solutions.add(temp1);
    int attempts = 10;

    while (attempts > 0) {
      List<List<dynamic>> temp2 = solver.createBoard(board);

      temp2 = solver.solveSudoku(temp2);
      for (int element = 0; element < solutions.length; element++) {
        if (DeepCollectionEquality().equals(solutions[element], temp2) ==
            false) {
          solutions.add(temp2);
        }
      }
      attempts -= 1;
      if (solutions.length > 1) {
        break;
      }
    }
    return temp1;
  }

  void createBoard() {
    eliminator(board);
    untouchables.clear();
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (board[r][c] != "") {
          untouchables.add([r, c]);
        }
      }
    }
    notifyListeners();
  }

  void createPuzzle() {
    board = board;
    untouchables.clear();
    notifyListeners();
  }

  String getBoardCell(int row, int col) {
    return this.board[row][col] == "" ? "" : this.board[row][col].toString();
  }

  Color getKeypadCellColor(bool hasBeenPressed) {
    return hasBeenPressed ? kAccentOrangeColor : kIconsColor;
  }

  bool checkUntouchable(int row, int col) {
    bool result = false;
    List<bool> results = [];
    List<int> selectedCell = [row, col];
    for (List element in untouchables) {
      if (DeepCollectionEquality().equals(element, selectedCell) == true) {
        results.add(true);
      } else {
        results.add(false);
      }
      if (results.contains(true) == false) {
        result = true;
      } else {
        result = false;
      }
    }
    return result;
  }

  void printNumber(dynamic number) {
    print(number.toString() + " was pressed");
    this.selectedNumber = number;
    if (selectedNumber == 0) {
      selectedNumber = "";
    }
    notifyListeners();
  }

  void resetBoard() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (checkUntouchable(r, c) == true) {
          board[r][c] = "";
          notifyListeners();
        }
      }
    }
  }

  void selectBoardCell(int row, int col, bool creator) {
    if (checkUntouchable(row, col) == true && creator == false) {
      this.board[row][col] = selectedNumber;
      notifyListeners();
    }

    if (creator) {
      this.board[row][col] = selectedNumber;
      print(board);
      notifyListeners();
    }
  }

  void clearBoard() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        board[r][c] = "";
        notifyListeners();
      }
    }
  }

  bool checkComplete() {
    print("checking if complete");
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (board[r][c] == "") {
          print(solutions[0]);

          return false;
        }
      }
    }
    return true;
  }

  bool checkCorrect() {
    DeepCollectionEquality dc = DeepCollectionEquality();
    bool equals = dc.equals(board, solutions[0]);
    print(equals);
    return equals;
  }

  void saveBoard() async {
    LocalStorage storage = LocalStorage('localStorage');
    final url = Uri.parse('$kUrl/sudoku/');
    final token = storage.getItem('token');
    await http.post(url,
        headers: {
          'Authorization': 'Bearer $token',
          "Content-type": "application/json"
        },
        body: jsonEncode({'puzzle': board}));
  }
}
