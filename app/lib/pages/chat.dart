import 'package:chat_app/custom_widgets/custom_send_button.dart';
import 'package:chat_app/custom_widgets/message.dart';
import 'package:chat_app/faker.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  static const id = 'CHAT';

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void sendMessage() {
    String message = messageController.text;
    if (message.length > 0) {
      Faker.messages.push({
        "content": message,
        ...Faker.currentUser,
      });
    }
  }

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                itemCount: Faker.messages.length,
                itemBuilder: (context, index) {
                  String messageContent = Faker.messages[index]['content'];
                  bool me = Faker.messages[index]['user']['username'] ==
                      Faker.currentUser['user']['username'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Message(
                        username: Faker.currentUser['user']['username'],
                        content: messageContent,
                        me: me),
                  );
                  // return ListTile(
                  //   title: Text(messageContent),
                  // );
                },
              )),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(hintText: 'Start typing...'),
                    )),
                    CustomSendButton(text: 'Send', callback: sendMessage),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
