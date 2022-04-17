import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/screens/Home.dart';
import 'package:sudoku/screens/Login.dart';
import 'package:sudoku/widgets/SudokuChangeNotifier.dart';

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
          create: (context) => SudokuChangeNotifier(),
          child: LoginPageWidget(),
        ));
  }
}
