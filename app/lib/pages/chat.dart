import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  static const id = 'CHAT';

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Chat'),
    );
  }
}
