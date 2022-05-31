import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/screens/themes.dart';
import 'package:sudoku/widgets/SudokuChangeNotifier.dart';

class KeypadCell extends StatefulWidget {
  final int number;

  KeypadCell(this.number);

  @override
  State<KeypadCell> createState() => _KeypadCellState();
}

class _KeypadCellState extends State<KeypadCell> {
  final change = SudokuChangeNotifier();
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return (Consumer<SudokuChangeNotifier>(
        builder: (context, numberPicker, child) {
          return Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
              child: SizedBox(
                width: 55,
                height: 50,
                child: MaterialButton(
                  onPressed: () {
                    print(numberPicker.selectedNumber);
                    Provider.of<SudokuChangeNotifier>(context, listen: false)
                        .printNumber(widget.number);
                    print(widget.number == numberPicker.selectedNumber);

                  },
                  child: Text(
                    '${widget.number}',
                    style: kButtonText1,
                  ),
                  color: _isSelected ? kAccentOrangeColor : kIconsColor,
                  shape: const CircleBorder(
                    side: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                  ),
                ),
              ));
        }));
  }
}
