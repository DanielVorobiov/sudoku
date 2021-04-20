import 'package:flutter/material.dart';
import 'package:sudoku/SudokuChangeNotifier.dart';
import 'package:provider/provider.dart';

class SolveButton extends StatefulWidget {
  @override
  _SolveButtonState createState() => _SolveButtonState();
}

class _SolveButtonState extends State<SolveButton> {

  final change = new SudokuChangeNotifier();
  @override
  Widget build(BuildContext context) {
    return (Consumer<SudokuChangeNotifier>(
        builder: (context, sudokuChangeNotifier, child) {
      return ElevatedButton(
        onPressed: () {
          print("New puzzle created");
          Provider.of<SudokuChangeNotifier>(context, listen: false)
              .createBoard();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            foregroundColor: MaterialStateProperty.all(Colors.white)),
        child: Text('New Puzzle'),
      );
    }));
  }
}
