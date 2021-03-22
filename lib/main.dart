import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/ResetButtton.dart';
import 'package:sudoku/SolveButton.dart';
import 'package:sudoku/SudokuBoard.dart';
import 'package:sudoku/Keypad.dart';
import 'package:sudoku/SudokuChangeNotifier.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(     
        create:(context) => SudokuChangeNotifier(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Sudoku!"),
          ),
          body: Column(
            children: [
              Expanded(
                flex:6,
                child: SudokuBoard(),
                ),
              Expanded(
                flex:2,
                child: Keypad()),
              Expanded(
                flex: 1,
                child: Row(children: [
                  Expanded(
                    flex: 5,
                      child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,0,20,50),
                      child: SolveButton(),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                      child: Padding(
                      padding: const EdgeInsets.fromLTRB(20,0,20,50),
                      child: ResetButton(),
                    ),
                  )
                ],),)
            ],
          )
    ),
      ));
  }
}
