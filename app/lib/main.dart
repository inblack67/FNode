import 'package:chat_app/pages/chat.dart';
import 'package:chat_app/pages/home.dart';
import 'package:chat_app/pages/login.dart';
import 'package:chat_app/pages/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flix',
      theme: ThemeData.dark(),
      initialRoute: HomePage.id,
      routes: {
        HomePage.id: (context) => HomePage(),
        Login.id: (context) => Login(),
        Register.id: (context) => Register(),
        Chat.id: (context) => Chat(),
      },
    );
  }
}
