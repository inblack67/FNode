import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String username;
  final String content;
  final bool me;

  Message({required this.username, required this.content, required this.me});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            color: me ? Colors.teal : Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Text(content),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text(username),
        ],
      ),
    );
  }
}
