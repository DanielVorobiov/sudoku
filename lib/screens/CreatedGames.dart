import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:sudoku/consts.dart';
import 'package:sudoku/models/SudokuModel.dart';
import 'package:sudoku/screens/Home.dart';
import 'package:sudoku/screens/themes.dart';

class CreatedGamesWidget extends StatefulWidget {
  const CreatedGamesWidget({Key? key}) : super(key: key);

  @override
  _CreatedGamesWidgetState createState() => _CreatedGamesWidgetState();
}

class _CreatedGamesWidgetState extends State<CreatedGamesWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final LocalStorage storage = LocalStorage('localStorage');
  late Future<List<SudokuModel>> puzzles;

  Future<List<SudokuModel>> fetchPuzzles() async {
    final token = storage.getItem('token');
    final response = await http.get(Uri.parse(kUrl + '/sudoku/own/'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      final puzzles =
          jsonResponse.map((data) => SudokuModel.fromJson(data)).toList();
      return puzzles;
    } else {
      print(response.statusCode);
      throw Exception('Unexpected error occurred!');
    }
  }

  Future<void> _pullRefresh() async {
    setState(() {
      puzzles = fetchPuzzles();
    });
  }

  @override
  void initState() {
    super.initState();
    puzzles = fetchPuzzles();
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
              child: Text('${storage.getItem('firstName')}\'s created puzzles',
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
                  future: puzzles,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<SudokuModel>? puzzles =
                          snapshot.data as List<SudokuModel>?;
                      return RefreshIndicator(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: puzzles?.length,
                              itemBuilder: (BuildContext context, int index) {
                                print(puzzles![index].createdOn);
                                return puzzleCard(puzzles![index], index);
                              }),
                          onRefresh: _pullRefresh);
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
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

  Widget puzzleCard(puzzle, index) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
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
                        Text('Puzzle ${index+1}', style: kNameText),
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
                          '${puzzle.complexity}',
                          style: kStatsBodyText,
                        ),
                        Text(
                          '${puzzle.createdOn}',
                          style: kBodyText1Black,
                        ),
                        Text(
                          '${puzzle.createdAt}',
                          style: kBodyText1Black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
