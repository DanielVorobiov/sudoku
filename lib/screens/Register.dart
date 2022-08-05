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
import '../mixins/validation_mixin.dart';

class RegisterPageWidget extends StatefulWidget {
  const RegisterPageWidget({Key? key}) : super(key: key);

  @override
  _RegisterPageWidgetState createState() => _RegisterPageWidgetState();
}

class _RegisterPageWidgetState extends State<RegisterPageWidget>
    with ValidationMixin {
  late TextEditingController nicknameController;
  late TextEditingController emailAddressController;
  late TextEditingController passwordController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storage = LocalStorage('localStorage');
  bool _validate = false;

  @override
  void initState() {
    super.initState();

    nicknameController = TextEditingController();
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
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 200),
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
                    child: Column(
                      children: [
                        formField(
                            nicknameController, 'Nickname', validateNickname),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: formField(
                            emailAddressController,
                            'Email address',
                            validateEmail,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: formField(
                            passwordController,
                            'Password',
                            validatePassword,
                          ),
                        ),
                      ],
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
                            setState(() {
                              nicknameController.text.isEmpty
                                  ? _validate = true
                                  : _validate = false;
                            });
                            if (_formKey.currentState!.validate()) {
                              String nickname = nicknameController.text;
                              final email = emailAddressController.text;
                              final password = passwordController.text;
                              var url = Uri.parse('$kUrl/user/register/');
                              final headers = {
                                "Content-type": "application/json",
                              };
                              var response = await http.post(url,
                                  headers: headers,
                                  body: jsonEncode(UserModel(
                                          nickname: nickname,
                                          email: email,
                                          password: password)
                                      .toMap()));
                              if (response.statusCode == 201) {
                                storage.setItem('token',
                                    jsonDecode(response.body)['access']);
                                storage.setItem('nickname', nickname);
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

  Widget formField(
    TextEditingController controller,
    String label,
    validator,
  ) {
    return TextFormField(
        controller: controller,
        obscureText: false,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: kHintText,
            floatingLabelStyle: TextStyle(color: Colors.white),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: 'Enter your ${label.toLowerCase()}...',
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
            contentPadding: EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
              width: 2,
              color: Colors.red,
            ))),
        validator: validator,
        style: kHintText);
  }
}
