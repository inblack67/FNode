import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static const id = 'LOGIN';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Login'),
    );
  }
}
