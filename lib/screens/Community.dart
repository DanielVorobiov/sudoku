import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:sudoku/consts.dart';
import 'package:sudoku/models/UserModel.dart';
import 'package:sudoku/screens/Home.dart';
import 'package:sudoku/screens/Statistics.dart';
import 'package:sudoku/screens/themes.dart';

class CommunityWidget extends StatefulWidget {
  const CommunityWidget({Key? key}) : super(key: key);

  @override
  _CommunityWidgetState createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalStorage storage = LocalStorage('localStorage');
  late Future<List<UserModel>> users;

  Future<List<UserModel>> fetchUsers() async {
    final token = storage.getItem('token');
    final response = await http.get(Uri.parse(kUrl + '/user/'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      final users =
          jsonResponse.map((data) => UserModel.fromJson(data)).toList();
      return users;
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  Future<void> _pullRefresh() async {
    setState(() {
      users = fetchUsers();
    });
  }

  @override
  void initState() {
    super.initState();
    users = fetchUsers();
  }

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
              child: Text('Community Members',
                  style: kBodyText1White.copyWith(fontSize: 22)),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 2,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder(
                  future: users,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<UserModel>? users =
                          snapshot.data as List<UserModel>?;

                      return RefreshIndicator(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: users?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return userCard(users![index]);
                              }),
                          onRefresh: _pullRefresh);
                    } else if (snapshot.hasError) {
                      return const Text('Unexpected error from API');
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget userCard(user) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
            child: GestureDetector(
              onTap: () async {
                print("pressed");
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatsPageWidget(
                      userId: user.id,
                      firstName: user.firstName,
                      level: user.level,
                      xp: user.xp,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: Color(0xFFF5F5F5),
                elevation: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('${user.firstName}', style: kNameText),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Level ${user.level}',
                            style: kStatsBodyText,
                          ),
                          Text(
                            'XP ${user.xp}',
                            style: kStatsBodyText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
