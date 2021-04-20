import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/SudokuChangeNotifier.dart';

class KeypadCell extends StatelessWidget {
  final int number;
  KeypadCell(this.number);
  final change = new SudokuChangeNotifier();
  @override
  Widget build(BuildContext context) {
    return (Consumer<SudokuChangeNotifier>(
        builder: (context, numberPicker, child) {
          return SizedBox(
            width: 40,
            height: 40,
            child: MaterialButton(
              onPressed: () {
                Provider.of<SudokuChangeNotifier>(context, listen: false)
                    .printNumber(number);
              },
              child: Text('$number'),
            ),
          );
        }));
  }
}


