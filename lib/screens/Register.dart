import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sudoku/consts.dart';
import 'package:sudoku/models/UserModel.dart';
import 'package:sudoku/screens/Home.dart';
import 'package:sudoku/screens/Login.dart';
import 'package:sudoku/screens/themes.dart';
import 'package:http/http.dart' as http;

class RegisterPageWidget extends StatefulWidget {
  const RegisterPageWidget({Key? key}) : super(key: key);

  @override
  _RegisterPageWidgetState createState() => _RegisterPageWidgetState();
}

class _RegisterPageWidgetState extends State<RegisterPageWidget>
    with TickerProviderStateMixin {
  late TextEditingController firstNameController;
  late TextEditingController emailAddressController;
  late TextEditingController passwordController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storage = LocalStorage('localStorage');


  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController();
    emailAddressController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kIconsColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 100),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                    child: Text('Welcome to Sudoku the Game!',
                        textAlign: TextAlign.center,
                        style: kBodyText1White.copyWith(fontSize: 30)),
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                        controller: firstNameController,
                        obscureText: false,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: kHintText,
                          floatingLabelStyle: TextStyle(color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: 'Enter your first name...',
                          hintStyle: kHintText,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFDBE2E7),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFDBE2E7),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                        ),
                        style: kHintText),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailAddressController,
                      obscureText: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: kHintText,
                        hintText: 'Enter your email address...',
                        hintStyle: kHintText,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFDBE2E7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFDBE2E7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                      ),
                      style: kHintText,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: kHintText,
                        hintText: 'Enter your password...',
                        hintStyle: kHintText,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFDBE2E7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFDBE2E7),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                      ),
                      style: kHintText,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPageWidget(),
                              ),
                            );
                          },
                          child: Text('Log in'),
                          style: kHomeButtonStyle,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(200, 10, 0, 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String firstName = firstNameController.text;
                              final email = emailAddressController.text;
                              final password = passwordController.text;
                              var url = Uri.parse('$kUrl/user/');
                              final headers = {
                                "Content-type": "application/json",
                              };
                              var response = await http.post(url,
                                  headers: headers,
                                  body: jsonEncode(UserModel(
                                          firstName: firstName,
                                          email: email,
                                          password: password)
                                      .toMap()));
                              if (response.statusCode == 201) {
                                url = Uri.parse('$kUrl/user/token/');
                                response = await http.post(url,
                                    headers: headers,
                                    body: jsonEncode(UserModel(
                                        email: email,
                                        password: password)
                                        .toMap()));
                                storage.setItem('token', jsonDecode(response.body)['access']);
                                storage.setItem('firstName', firstName);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePageWidget(),
                                  ),
                                );
                              } else {
                                throw Exception("Something went wrong");
                              }
                            }
                          },
                          child: Text('Register'),
                          style: kHomeButtonStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
