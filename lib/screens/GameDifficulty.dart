import 'package:flutter/material.dart';
import 'package:sudoku/screens/Game.dart';
import 'package:sudoku/screens/Home.dart';
import 'package:sudoku/screens/themes.dart';

class GameDifficultyWidget extends StatefulWidget {
  const GameDifficultyWidget({Key key}) : super(key: key);

  @override
  _GameDifficultyWidgetState createState() => _GameDifficultyWidgetState();
}

class _GameDifficultyWidgetState extends State<GameDifficultyWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePageWidget(),
              ),
            );
          },
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 250, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    difficultyButton('Easy', kIconsColor),
                    difficultyButton('Medium', kAccentOrangeColor),
                    difficultyButton('Hard', kPrimaryColor)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget difficultyButton(text, color) {
    return SizedBox(
      width: 100,
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GamePageWidget(),
            ),
          );
        },
        child: Text(text, style: kButtonText1.copyWith(color:color),),
        style: kDifficultyButtonStyle,
      ),
    );
  }
}
