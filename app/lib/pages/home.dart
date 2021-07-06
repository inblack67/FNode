import 'package:chat_app/custom_widgets/custom_button.dart';
import 'package:chat_app/pages/chat.dart';
import 'package:chat_app/pages/login.dart';
import 'package:chat_app/pages/register.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const id = 'HOME';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                    tag: 'logo',
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/black.jpg',
                      ),
                      radius: 70.0,
                    )),
              ),
              Text(
                'Flix',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[100],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          CustomButton(
              title: 'Register',
              callback: () {
                Navigator.of(context).pushNamed(Register.id);
              }),
          CustomButton(
              title: 'Login',
              callback: () {
                Navigator.of(context).pushNamed(Login.id);
              }),
          CustomButton(
              title: 'Chat',
              callback: () {
                Navigator.of(context).pushNamed(Chat.id);
              }),
        ],
      ),
    );
  }
}
