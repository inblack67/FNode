import 'package:chat_app/pages/chat.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  static const id = 'REGISTER';

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  String email = '';
  String password = '';

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
      body: Column(
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
          TextField(),
          TextField(),
        ],
      ),
    );
  }
}
