import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import '../constants.dart';
import 'chat_screen.dart';
import 'welcome_screen.dart';
import 'welcome_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'screens/registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 100.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
                print(value);
              },
              decoration: kbuildTextField.copyWith(hintText: 'Enter your email'),
            ),
            SizedBox(
              height: 4.0,
            ),
            TextField(
            textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                password = value;
                print(password);

              },
              decoration: kbuildTextField.copyWith(hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 12.0,
            ),
            RoundeButton(
              title: 'Register',
              colour: Colors.red,
              onPressed: () async {
                try {
                  final newUser =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  if (newUser != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                }
                catch (e) {
                  print(e);
                }

              },
                ),
              ],
            ),
        ));
  }


}
