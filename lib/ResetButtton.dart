import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SudokuChangeNotifier.dart';

class ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Consumer<SudokuChangeNotifier>(
        builder: (context, sudokuChangeNotifier, child) {
    return ElevatedButton(
    onPressed: () {

    Provider.of<SudokuChangeNotifier>(context, listen: false)
        .resetBoard();
    },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          foregroundColor: MaterialStateProperty.all(Colors.white)),
      child: Text('Reset Board'),
    );
        }));
  }
}
