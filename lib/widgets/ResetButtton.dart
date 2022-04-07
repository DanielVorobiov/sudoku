import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/screens/themes.dart';

import 'SudokuChangeNotifier.dart';

class ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Consumer<SudokuChangeNotifier>(
        builder: (context, sudokuChangeNotifier, child) {
      return SizedBox(
        width: 150,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            Provider.of<SudokuChangeNotifier>(context, listen: false)
                .resetBoard();
          },
          child: Text('Reset Board'),
          style: kHomeButtonStyle,
        ),
      );
    }));
  }
}
