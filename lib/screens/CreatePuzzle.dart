import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:sudoku/screens/CreatedGames.dart';
import 'package:sudoku/screens/Home.dart';
import 'package:sudoku/screens/themes.dart';
import 'package:sudoku/widgets/Keypad.dart';
import 'package:sudoku/widgets/SudokuBoard.dart';
import 'package:sudoku/widgets/SudokuChangeNotifier.dart';

class CreateGamePageWidget extends StatefulWidget {
  const CreateGamePageWidget({Key? key}) : super(key: key);

  @override
  _CreateGamePageWidgetState createState() => _CreateGamePageWidgetState();
}

class _CreateGamePageWidgetState extends State<CreateGamePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  final _scrollController = ScrollController();

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
          title: Text("Create a puzzle"),
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
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: SudokuBoard(true),
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
            Provider.of<SudokuChangeNotifier>(context, listen: false)
                .saveBoard();
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => puzzleCreatedDialog());
          },
          child: Text('Save Puzzle'),
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
                .clearBoard();
          },
          child: Text('Reset Board'),
          style: kHomeButtonStyle,
        ),
      );
    }));
  }

  Widget puzzleCreatedDialog() {
    return AlertDialog(
      title: Text('Puzzle created successfully'),
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
                  builder: (context) => CreatedGamesWidget(),
                ),
              );
            },
            child: Text('Check it out',
                style: kDialogText.copyWith(fontWeight: FontWeight.w600)))
      ],
      titleTextStyle: kBodyText1Black.copyWith(fontSize: 20),
    );
  }
}
