import 'dart:convert';

import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/entities/user.dart';
import 'package:chat_app/interfaces/api.dart';
import 'package:chat_app/pages/login.dart';
import 'package:chat_app/utils/protect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  static const id = 'REGISTER';

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _user = User();

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

  Future<void> registerUser() async {
    final form = _formKey.currentState;
    final _registerEndpoint = IAPI.url + IAPI.register;

    if (form != null && form.validate()) {
      form.save();
      Map<String, String> user = {
        'name': _user.name,
        'email': _user.email,
        'password': _user.password,
        'username': _user.username,
      };
      var res = await http.post(Uri.parse(_registerEndpoint),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(user));
      var resBody = json.decode(res.body);
      if (resBody['success']) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Register'),
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
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                ),
                onChanged: (val) => _user.name = val,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => _user.email = val,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                onChanged: (val) => _user.password = val,
                decoration: InputDecoration(
                  hintText: 'Enter password',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                onChanged: (val) => _user.username = val,
                decoration: InputDecoration(
                  hintText: 'Enter username',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.0),
              CustomButton(title: 'Submit', callback: registerUser),
            ],
          ),
        ),
      ),
    );
  }
}
