import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/screens/themes.dart';
import 'package:sudoku/widgets/KeypadCell.dart';

import 'SudokuChangeNotifier.dart';

class Keypad extends StatefulWidget {
  @override
  State<Keypad> createState() => _KeypadState();
}

class _KeypadState extends State<Keypad> {


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    KeypadCell(1),
                    KeypadCell(2),
                    KeypadCell(3),
                    KeypadCell(4),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    KeypadCell(5),
                    KeypadCell(6),
                    KeypadCell(7),
                    KeypadCell(8),
                    KeypadCell(9),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 55,
          height: 50,
          child: MaterialButton(
            onPressed: () {
              Provider.of<SudokuChangeNotifier>(context, listen: false)
                  .printNumber(0);
            },
            child: Icon(
              Icons.delete_forever_outlined,
              color: Colors.white,
              size: 25,
            ),
            color: kIconsColor,
            shape: const CircleBorder(
              side: BorderSide(
                color: kIconsColor,
                width: 1,
              ),
            ),
          ),
        )
      ],
    );
  }
}
