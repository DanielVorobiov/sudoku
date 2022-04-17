import 'package:flutter/material.dart';
import 'package:sudoku/widgets/SudokuChangeNotifier.dart';
import 'package:provider/provider.dart';

class SudokuCell extends StatefulWidget {
  final int row, col;
  final bool creator;
  SudokuCell(this.row, this.col, this.creator);

  @override
  _SudokuCellState createState() => _SudokuCellState();
}

class _SudokuCellState extends State<SudokuCell> {
  final change = new SudokuChangeNotifier();

  @override
  Widget build(BuildContext context) {
    return (Consumer<SudokuChangeNotifier>(builder: (context, unt, child) {
      return SizedBox(
          width: 48,
          height: 48,
          child: Container(
            child: MaterialButton(
              onPressed: () {
                Provider.of<SudokuChangeNotifier>(context, listen: false)
                    .selectBoardCell(widget.row, widget.col, widget.creator);
              },
              child: Center(
                  child: Selector<SudokuChangeNotifier, String>(
                      selector: (context, sudokuChangeNotifier) =>
                          sudokuChangeNotifier.getBoardCell(
                              widget.row, widget.col),
                      builder: (context, value, child) {
                        {
                          return Text(
                            value,
                          );
                        }
                      })),
            ),
          ));
    }));
  }
}
