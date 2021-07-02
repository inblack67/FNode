import 'dart:convert';

import 'package:chat_app/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  static const id = 'REGISTER';

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  String email = '';
  String password = '';

  final String API_URL = 'http://localhost:5000/';
  Map<String, dynamic> pong = {};

  Future<void> pingAPI() async {
    try {
      var res = await http
          .get(Uri.parse(API_URL), headers: {"Accept": "application/json"});
      var resBody = json.decode(res.body);
      setState(() {
        pong = resBody;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    this.pingAPI();
  }

  Future<void> registerUser() async {
    print(email);
    print(password);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
            SizedBox(height: 18.0),
            TextField(
              onChanged: (val) => email = val,
            ),
            TextField(
              onChanged: (val) => password = val,
            ),
            Text(pong['success'] == null ? 'Loading' : pong['message'])
          ],
        ),
      ),
    );
  }
}
