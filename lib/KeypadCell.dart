import 'package:flutter/material.dart';
import 'package:sudoku/Solver.dart';
import 'package:sudoku/SudokuBoard.dart';

class KeypadCell extends StatelessWidget {
  final int number;
  KeypadCell(this.number);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: MaterialButton(
        onPressed: () {},
        child: Text('$number'),
      ),
    );
  }
}
