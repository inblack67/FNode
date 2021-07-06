import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  static const id = 'CHAT';

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Hero(
            tag: 'logo',
            child: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/black.jpg',
              ),
              radius: 100.0,
            )),
        title: Text('FNode'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                // @TODO => sign out
              },
              icon: Icon(
                Icons.close,
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[],
        ),
      ),
    );
  }
}
