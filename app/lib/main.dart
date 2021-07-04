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
      debugShowCheckedModeBanner: false,
      title: 'Flix',
      initialRoute: HomePage.id,
      theme: ThemeData.dark(),
      routes: {
        HomePage.id: (context) => HomePage(),
        Login.id: (context) => Login(),
        Register.id: (context) => Register(),
        Chat.id: (context) => Chat(),
      },
    );
  }
}
