import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:sudoku/consts.dart';
import 'package:sudoku/models/StatisticsModel.dart';
import 'package:sudoku/screens/Home.dart';
import 'package:sudoku/screens/themes.dart';

class StatsPageWidget extends StatefulWidget {
  final int userId;
  final int? level;
  final int? xp;
  final String? firstName;

  const StatsPageWidget(
      {required this.userId, this.level, this.xp, this.firstName, Key? key})
      : super(key: key);

  @override
  _StatsPageWidgetState createState() => _StatsPageWidgetState();
}

class _StatsPageWidgetState extends State<StatsPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalStorage storage = LocalStorage('localStorage');
  late Future<StatisticsModel> statisticsData;
  String url = '';
  bool owner = false;
  int? level = 0;
  int? xp = 0;
  String? firstName = '';

  Future<StatisticsModel> fetchStats() async {
    final token = storage.getItem('token');
    if (storage.getItem('id') == widget.userId) {
      url = '/statistics/my-statistics/';
      owner = true;
      level = storage.getItem('level');
      xp = storage.getItem('xp');
      firstName = storage.getItem('firstName');
    } else {
      url = '/statistics/${widget.userId}/';
      level = widget.level;
      xp = widget.xp;
      firstName = widget.firstName;
    }
    final response = await http.get(Uri.parse(kUrl + url),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      final statistics = StatisticsModel.fromJson(jsonResponse);
      return statistics;
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  Future<void> _pullRefresh() async {
    setState(() {
      statisticsData = fetchStats();
    });
  }

  @override
  void initState() {
    super.initState();
    statisticsData = fetchStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFF6511D),
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
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Home',
              style: kButtonText1,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
              child: Text('${widget.firstName}\'s Statistics',
                  style: kBodyText1White.copyWith(fontSize: 22)),
            ),
          ],
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 15, 20, 0),
            child: FutureBuilder(
                future: statisticsData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    StatisticsModel? statistics =
                        snapshot.data as StatisticsModel?;
                    return RefreshIndicator(
                      onRefresh: _pullRefresh,
                      color: kAccentOrangeColor,
                      child: Align(
                        alignment: AlignmentDirectional(-0.1, 0),
                        child: statisticsWidget(statistics, owner),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Unexpected error from API');
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ));
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget statisticsWidget(statistics, owner) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.trending_up_sharp,
              color: kIconsColor,
              size: 24,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
              child: Text('Level: ${widget.level}', style: kStatsHeaderText),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.stars_outlined,
              color: kIconsColor,
              size: 24,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 7, 0, 0),
              child: Text('XP: ${widget.xp}', style: kStatsHeaderText),
            ),
          ],
        ),
        Divider(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.category,
                        color: kIconsColor,
                        size: 24,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 5, 0, 0),
                        child: Text(
                            'Puzzles created: ${statistics.puzzleCreatedNumberMedium}',
                            style: kStatsHeaderText),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.extension_outlined,
                        color: kIconsColor,
                        size: 24,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 5, 0, 0),
                        child: Text('Played games:', style: kStatsHeaderText),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 30, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Easy level: ${statistics?.gamesNumberEasy}',
                        style: kStatsBodyText),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Text(
                          'Medium level: ${statistics?.gamesNumberMedium}',
                          style: kStatsBodyText),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Text('Hard level: ${statistics?.gamesNumberHard}',
                          style: kStatsBodyText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.timer_sharp,
                        color: kIconsColor,
                        size: 24,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 5, 0, 0),
                        child: Text('Best time:', style: kStatsHeaderText),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 30, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Easy level: ${statistics?.bestTimeEasy}',
                        style: kStatsBodyText),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Text('Medium level: ${statistics?.bestTimeMedium}',
                          style: kStatsBodyText),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: Text('Hard level: ${statistics?.bestTimeHard}',
                          style: kStatsBodyText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
