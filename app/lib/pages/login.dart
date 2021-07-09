import 'dart:convert';

import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/interfaces/api.dart';
import 'package:chat_app/interfaces/login_response.dart';
import 'package:chat_app/pages/chat.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/hive.dart';
import 'package:chat_app/utils/protect.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static const id = 'LOGIN';

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';

  Future<void> protectMe() async {
    bool isAllowed = await Protect.allowed(authenticated: false);
    if (!isAllowed) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  void initState() {
    super.initState();
    protectMe();
  }

  Future<void> loginUser() async {
    final form = _formKey.currentState;
    final _loginEndpoint = IAPI.url + IAPI.login;

    if (form != null && form.validate()) {
      form.save();
      Map<String, String> user = {
        'username': _username,
        'password': _password,
      };
      var res = await http.post(Uri.parse(_loginEndpoint),
          headers: <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(user));
      var resBody = json.decode(res.body);
      // print(resBody);
      if (resBody['success']) {
        var res = RLogin.successResponsefromJSON(resBody);
        String token = res.data['token'];

        final _tokensEncryptionBox =
            await MHive.getEncryptionBox(Constants.tokensEncryptionBoxName);

        bool addSecretRes = await MHive.addSecret(
            _tokensEncryptionBox, Constants.tokenKey, token);

        if (addSecretRes) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Chat()));
        }
      } else {
        print(resBody['error']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
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
                        'assets/images/black.jpg',
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
