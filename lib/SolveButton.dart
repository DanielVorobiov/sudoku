import 'package:flutter/material.dart';

class SolveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print("Solve Button pressed");
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          foregroundColor: MaterialStateProperty.all(Colors.white)),
      child: Text('solve'),
    );
  }
}
