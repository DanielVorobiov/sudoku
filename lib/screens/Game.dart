import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/screens/Home.dart';
import 'package:sudoku/screens/themes.dart';
import 'package:sudoku/widgets/Keypad.dart';
import 'package:sudoku/widgets/ResetButtton.dart';
import 'package:sudoku/widgets/SolveButton.dart';
import 'package:sudoku/widgets/SudokuBoard.dart';
import 'package:sudoku/widgets/SudokuChangeNotifier.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class GamePageWidget extends StatefulWidget {
  const GamePageWidget({Key key}) : super(key: key);

  @override
  _GamePageWidgetState createState() => _GamePageWidgetState();
}

class _GamePageWidgetState extends State<GamePageWidget> {
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
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
              child: StreamBuilder<int>(
                  stream: _stopWatchTimer.secondTime,
                  initialData: _stopWatchTimer.secondTime.value,
                  builder: (context, snap) {
                    var displayTime =
                        StopWatchTimer.getDisplayTime(_stopWatchTimer.rawTime.value, hours: false, milliSecond: false);
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
                                onPressed: () {
                                  print('Button pressed ...');
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
                                child: SudokuBoard(),
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
                                children: [newPuzzleButton(), ResetButton()],
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
            _stopWatchTimer.onExecute
                .add(StopWatchExecute.reset);
            _stopWatchTimer.onExecute
                .add(StopWatchExecute.start);
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
}
