import 'package:flutter/material.dart';

class SudokuSolverPage extends StatefulWidget {
  @override
  _SudokuSolverPageState createState() => _SudokuSolverPageState();
}

class _SudokuSolverPageState extends State<SudokuSolverPage> {
  List<int> _activeNumber = [0];
  List<List<int>> _board = List.generate(9,(_) => List.generate(9, (_) => 0));

  //final solver = SudokuSolver()

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
