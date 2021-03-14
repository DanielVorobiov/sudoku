import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print("Reset Butotn Pressed");
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          foregroundColor: MaterialStateProperty.all(Colors.white)),
      child: Text('Reset Board'),
    );
  }
}
