import 'package:flutter/material.dart';

class SudokuCell extends StatelessWidget {
  final int row, col;
  SudokuCell(this.row, this.col);
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      enableFeedback: true,
      onTap: () {
        debugPrint('Setting ($row, $col) to active_number');
      },
      child: SizedBox(
        width: 48,
        height: 48,
        child: Container(
          child: Center(child: Text(''),),
        ),
      ),
    );
  }
}
