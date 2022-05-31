import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:sudoku/consts.dart';
import 'package:sudoku/models/UserModel.dart';
import 'package:sudoku/screens/Home.dart';
import 'package:sudoku/screens/Register.dart';
import 'package:sudoku/screens/themes.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({Key? key}) : super(key: key);

  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget>
    with TickerProviderStateMixin {
  late TextEditingController emailAddressController;
  late TextEditingController passwordController;
  final LocalStorage storage = LocalStorage('localStorage');
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
                  child: Text('Welcome back!',
                      textAlign: TextAlign.center,
                      style: kBodyText1White.copyWith(fontSize: 30)),
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                      controller: emailAddressController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle: kHintText,
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: 'Enter your email...',
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
                              builder: (context) => RegisterPageWidget(),
                            ),
                          );
                        },
                        child: Text('Create account'),
                        style: kHomeButtonStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(150, 10, 0, 0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final email = emailAddressController.text;
                            final password = passwordController.text;
                            final url = Uri.parse('$kUrl/user/token/');
                            final headers = {
                              "Content-type": "application/json",
                            };
                            final response = await http.post(url,
                                headers: headers,
                                body: jsonEncode(
                                    UserModel(email: email, password: password)
                                        .toMap()));
                            if (response.statusCode == 200) {
                              await storage.setItem(
                                  'token', jsonDecode(response.body)['access']);
                              await storage.setItem('userId', jsonDecode(response.body)['id']);

                              print("!!!");
                              print(storage.getItem('token'));
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePageWidget(),
                                ),
                              );
                            }
                          }
                        },
                        child: Text('Enter'),
                        style: kHomeButtonStyle,
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
}
