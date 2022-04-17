import 'package:flutter/material.dart';
import 'package:sudoku/logic/Solver.dart';
import 'package:sudoku/widgets/SudokuCell.dart';

class SudokuBoard extends StatelessWidget {
  final creator;
  SudokuBoard(this.creator);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Table(
            border: TableBorder(
              left: BorderSide(width: 3, color: Colors.black),
              top: BorderSide(width: 3, color: Colors.black),
            ),
            defaultColumnWidth: FixedColumnWidth(40),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: _getTableRows()),
      ],
    );
  }


  //List<List<dynamic>>

  List<TableRow> _getTableRows() {
    return List.generate(9, (int rowNumber) {
      return TableRow(children: _getRow(rowNumber));
    });
  }

  List<Widget> _getRow(int rowNumber) {
    return List.generate(9, (int colNumber) {
      return Container(
          decoration: BoxDecoration(
              border: Border(
            right: BorderSide(
                width: (colNumber % 3 == 2) ? 3.0 : 1.0, color: Colors.black),
            bottom: BorderSide(
                width: (rowNumber % 3 == 2) ? 3.0 : 1.0, color: Colors.black),
          )),
          child: SudokuCell(rowNumber, colNumber, creator));
    });
  }
}


