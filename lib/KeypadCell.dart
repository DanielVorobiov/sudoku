import 'package:flutter/material.dart';

class KeypadCell extends StatelessWidget {
  final int number;
  KeypadCell(this.number);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: MaterialButton(
        onPressed: () {
          final String message =
              number == 0 ? "Use to clear" : 'Fill squares with $number';
          debugPrint(message);
        },
        child: Text('$number'),
      ),
    );
  }
}
