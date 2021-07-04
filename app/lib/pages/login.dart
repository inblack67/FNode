import 'dart:convert';

import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/interfaces/api.dart';
import 'package:chat_app/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static const id = 'LOGIN';

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _api = IAPI();

  String _username = '';
  String _password = '';

  Future<void> loginUser() async {
    final form = _formKey.currentState;
    final _loginEndpoint = _api.url + _api.login;

    if (form != null && form.validate()) {
      form.save();
      Map<String, String> user = {
        'username': _username,
        'password': _password,
      };
      var res = await http.post(Uri.parse(_loginEndpoint),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(user));
      var resBody = json.decode(res.body);
      print(resBody);
      if (resBody['success']) {
        print(resBody['message']);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Chat()));
      } else {
        print(resBody['error']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Hero(
                    tag: 'logo',
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/elixir.jpeg',
                      ),
                      radius: 70.0,
                    )),
              ),
              SizedBox(height: 40.0),
              TextFormField(
                decoration: InputDecoration(hintText: 'Enter your username'),
                onChanged: (val) => _username = val,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                onChanged: (val) => _password = val,
                decoration: InputDecoration(hintText: 'Enter password'),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.0),
              CustomButton(title: 'Submit', callback: loginUser),
            ],
          ),
        ),
      ),
    );
  }
}
