import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:sudoku/consts.dart';
import 'package:sudoku/models/StatisticsModel.dart';
import 'package:sudoku/screens/CreatedGames.dart';
import 'package:sudoku/screens/GameDifficulty.dart';
import 'package:sudoku/screens/Home.dart';
import 'package:sudoku/screens/themes.dart';
import 'package:sudoku/widgets/Keypad.dart';
import 'package:sudoku/widgets/SudokuBoard.dart';
import 'package:http/http.dart' as http;

import 'package:sudoku/widgets/SudokuChangeNotifier.dart';

class GamePageWidget extends StatefulWidget {
  final String difficulty;

  const GamePageWidget({required this.difficulty, Key? key}) : super(key: key);

  @override
  _GamePageWidgetState createState() => _GamePageWidgetState();
}

class _GamePageWidgetState extends State<GamePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );
  bool complete = false;
  final LocalStorage storage = LocalStorage('localStorage');

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SudokuChangeNotifier(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sudoku!"),
          backgroundColor: kPrimaryColor,
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
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
              child: StreamBuilder<int>(
                  stream: _stopWatchTimer.secondTime,
                  initialData: _stopWatchTimer.secondTime.value,
                  builder: (context, snap) {
                    var displayTime = StopWatchTimer.getDisplayTime(
                        _stopWatchTimer.rawTime.value,
                        hours: false,
                        milliSecond: false);
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Time: ', style: kBodyText1Black),
                            Text(
                              displayTime.toString(),
                              style: kBodyText1Black,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(150, 0, 0, 0),
                              child: TextButton.icon(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePageWidget(),
                                    ),
                                  );
                                },
                                label: Text(
                                  'Quit',
                                  style: TextStyle(
                                      fontFamily: 'Work Sans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                icon: Icon(
                                  Icons.sentiment_very_dissatisfied_sharp,
                                  size: 15,
                                ),
                                style: TextButton.styleFrom(
                                    primary: kAccentOrangeColor),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: SudokuBoard(false),
                              ),
                            ),
                            Keypad(),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [newPuzzleButton(), resetButton()],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 15, 0, 0),
                              child: finishButton(),
                            )
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget newPuzzleButton() {
    return (Consumer<SudokuChangeNotifier>(
        builder: (context, sudokuChangeNotifier, child) {
      return SizedBox(
        width: 150,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
            _stopWatchTimer.onExecute.add(StopWatchExecute.start);
            print("New puzzle created");
            Provider.of<SudokuChangeNotifier>(context, listen: false)
                .createBoard();
          },
          child: Text('New Puzzle'),
          style: kHomeButtonStyle,
        ),
      );
    }));
  }

  Widget resetButton() {
    return (Consumer<SudokuChangeNotifier>(
        builder: (context, sudokuChangeNotifier, child) {
      return SizedBox(
        width: 150,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            Provider.of<SudokuChangeNotifier>(context, listen: false)
                .resetBoard();
            if (_stopWatchTimer.isRunning) {
              _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
              _stopWatchTimer.onExecute.add(StopWatchExecute.start);
            }
          },
          child: Text('Reset Board'),
          style: kHomeButtonStyle,
        ),
      );
    }));
  }

  Widget finishButton() {
    return (Consumer<SudokuChangeNotifier>(
        builder: (context, sudokuChangeNotifier, child) {
      return SizedBox(
        width: 150,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            complete = Provider.of<SudokuChangeNotifier>(context, listen: false)
                .checkComplete();
            if (complete) {
              bool correct =
                  Provider.of<SudokuChangeNotifier>(context, listen: false)
                      .checkCorrect();
              if (correct) {
                _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                updateStats(_stopWatchTimer.rawTime.value);
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => puzzleCompleteCorrect());
              } else {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => puzzleCompleteIncorrect());
              }
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => puzzleIncomplete());
            }
          },
          child: Text('Finish game'),
          style: kHomeButtonStyle,
        ),
      );
    }));
  }

  Widget puzzleCompleteCorrect() {
    return AlertDialog(
      title: Text('Good job, puzzle complete!'),
      actions: [
        TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePageWidget(),
                ),
              );
            },
            child: Text('Home page', style: kDialogText)),
        TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDifficultyWidget(),
                ),
              );
            },
            child: Text('New game',
                style: kDialogText.copyWith(fontWeight: FontWeight.w600)))
      ],
      titleTextStyle: kBodyText1Black.copyWith(fontSize: 20),
    );
  }

  Widget puzzleCompleteIncorrect() {
    return AlertDialog(
      title: Text('Ops, looks like some numbers are placed incorrectly'),
      actions: [
        TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePageWidget(),
                ),
              );
            },
            child: Text('Home page', style: kDialogText)),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Back to the game',
                style: kDialogText.copyWith(fontWeight: FontWeight.w600)))
      ],
      titleTextStyle: kBodyText1Black.copyWith(fontSize: 20),
    );
  }

  Widget puzzleIncomplete() {
    return AlertDialog(
      title: Text('Puzzle not yet complete'),
      actions: [
        TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePageWidget(),
                ),
              );
            },
            child: Text('Quit anyway', style: kDialogText)),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Back to the game',
                style: kDialogText.copyWith(fontWeight: FontWeight.w600)))
      ],
      titleTextStyle: kBodyText1Black.copyWith(fontSize: 20),
    );
  }

  void updateStats(time) async {
    String bestTimeKey = 'best_time_${widget.difficulty}';
    String gamesNumberKey = 'games_number_${widget.difficulty}';
    Uri url =
        Uri.parse('$kUrl/statistics/${storage.getItem('userId').toString()}/');
    Map<String, String>? headers = {
      'Authorization': 'Bearer ${storage.getItem('token')}'
    };
    dynamic response = await http.get(url, headers: headers);
    dynamic stats = StatisticsModel.fromJson(json.decode(response.body));
    int gamesNumber = stats.gamesNumberMedium;
    print(url);
    print(headers);
    print(gamesNumber);
    print(time);
    await http.patch(url, headers: headers, body: {
      'games_number_medium': "1",
      'best_time_${widget.difficulty}': "02:08",
    });
    await http.patch(Uri.parse('$kUrl/user/${storage.getItem('userId')}'),
        headers: headers, body: {'xp': (storage.getItem('xp') + 10)});
  }
}
