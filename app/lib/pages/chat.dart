import 'dart:convert';

import 'package:chat_app/custom_widgets/custom_send_button.dart';
import 'package:chat_app/custom_widgets/message.dart';
import 'package:chat_app/faker.dart';
import 'package:chat_app/interfaces/api.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/hive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  static const id = 'CHAT';

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  String _me = '';
  String _token = '';

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void populateAuth() async {
    final _tokensEncryptionBox =
        await MHive.getEncryptionBox(Constants.tokensEncryptionBoxName);
    var token = await MHive.getSecret(_tokensEncryptionBox, Constants.tokenKey);
    var res = await http.get(Uri.parse(IAPI.url + IAPI.getMe), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var resBody = jsonDecode(res.body);
    print(resBody);
    if (resBody['success']) {
      String current_username = resBody['data']['username'];
      setState(() {
        _me = current_username;
        _token = token;
      });
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  void initState() {
    super.initState();
    populateAuth();
  }

  void sendMessage() {
    String message = messageController.text;
    if (message.length > 0) {
      print('new message');
      print(message);
    }
  }

  Future<void> signOut() async {
    try {
      var res = await http.post(Uri.parse(IAPI.url + IAPI.logout), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      });
      var resBody = jsonDecode(res.body);
      if (resBody['success']) {
        var _encryptedBox =
            await MHive.getEncryptionBox(Constants.tokensEncryptionBoxName);
        await MHive.deleteSecret(_encryptedBox, Constants.tokenKey);
      }
      print(resBody);
    } catch (e) {
      print(e);
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
                signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
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
                    child:
                        Message(username: _me, content: messageContent, me: me),
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
