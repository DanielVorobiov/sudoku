import 'package:flutter/material.dart';
import 'package:sudoku/SolveButton.dart';
import 'package:sudoku/Solver.dart';
import 'package:sudoku/SudokuChangeNotifier.dart';
import 'package:provider/provider.dart';

class SudokuCell extends StatefulWidget {
  final int row, col;

  SudokuCell(this.row, this.col);
  @override
  _SudokuCellState createState() => _SudokuCellState();
}

class _SudokuCellState extends State<SudokuCell> {
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      enableFeedback: true,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Container(
          child: Center(child: Selector<SudokuChangeNotifier, String>(
            selector: (context, sudokuChangeNotifier) => 
              sudokuChangeNotifier.getBoardCell(widget.row, widget.col),
              builder: (context, value, child) {
            return Text(value);
          })),
        ),
      ),
    );
  }
}
