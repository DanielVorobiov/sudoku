import 'package:flutter/material.dart';
import 'package:sudoku/KeypadCell.dart';

class Keypad extends StatelessWidget {
  final int numRows = 2;
  final int numColumns = 5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: Table(
        border: TableBorder.all(
          color: Colors.black,
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.top,
        children: _getTableRows(),
      ),
    );
  }

  List<TableRow> _getTableRows() {
    return List.generate(this.numRows, (int rowNumber) {
      return TableRow(children: _getRow(rowNumber));
    });
  }

  List<Widget> _getRow(int rowNumber) {
    return List.generate(this.numColumns, (int colNumber) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: KeypadCell(this.numColumns * rowNumber + colNumber ),
      );
    });
  }
}
