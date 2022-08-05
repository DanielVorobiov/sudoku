import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:sudoku/consts.dart';
import 'package:sudoku/models/UserModel.dart';
import 'package:sudoku/screens/Community.dart';
import 'package:sudoku/screens/CreatePuzzle.dart';
import 'package:sudoku/screens/CreatedGames.dart';
import 'package:sudoku/screens/GameDifficulty.dart';
import 'package:sudoku/screens/Login.dart';
import 'package:sudoku/screens/Statistics.dart';
import 'package:sudoku/screens/themes.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalStorage storage = LocalStorage('localStorage');
  late Future<UserModel> me;

  Future<UserModel> fetchMe() async {
    final token = storage.getItem('token');
    final response = await http.get(Uri.parse(kUrl + '/user/me/'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      final user = UserModel.fromJson(jsonResponse);
      await storage.setItem('userId', user.id);
      await storage.setItem('level', user.level);
      await storage.setItem('xp', user.xp);
      await storage.setItem('firstName', user.nickname);
      return user;
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  @override
  void initState() {
    super.initState();
    me = fetchMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Color(0xFFF6511D),
          automaticallyImplyLeading: false,
          flexibleSpace: Stack(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: FutureBuilder(
                            future: me,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                UserModel? me = snapshot.data as UserModel?;
                                return Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          25, 0, 50, 0),
                                      child: Text(
                                        'Level: ${me?.level}',
                                        style: kBodyText1White,
                                      ),
                                    ),
                                    SizedBox(
                                      child: Text(
                                        'XP: ${me?.xp}',
                                        style: kBodyText1White,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Text('${snapshot.error}');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 20, 0),
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LoginPageWidget(), //Login widget
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Log out ',
                                  style: kBodyText1White,
                                ),
                                Icon(
                                  Icons.exit_to_app,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          elevation: 3,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(25, 0, 20, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StatsPageWidget(
                                level: storage.getItem('level'),
                                xp: storage.getItem('xp'),
                                userId: storage.getItem('userId'),
                                firstName: storage.getItem('firstName'),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.bar_chart,
                              color: kIconsColor,
                              size: 30,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                              child: Text(
                                'Statistics',
                                style: kBodyText1Black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommunityWidget(), //profile page
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              color: kIconsColor,
                              size: 30,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                              child: Text(
                                'Community',
                                style: kBodyText1Black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                              child: basicGameButton()),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                            child: createPuzzleButton(),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                            child: createdGamesButton(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget basicGameButton() {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameDifficultyWidget(),
            ),
          );
        },
        child: Text('>     Basic Game'),
        style: kHomeButtonStyle,
      ),
    );
  }

  Widget createPuzzleButton() {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateGamePageWidget(), //game dificulty
            ),
          );
        },
        child: Text('>     Create puzzle'),
        style: kHomeButtonStyle,
      ),
    );
  }

  Widget createdGamesButton() {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatedGamesWidget(),
            ),
          );
        },
        child: Text('>     Created games'),
        style: kHomeButtonStyle,
      ),
    );
  }
}
