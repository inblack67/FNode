import 'dart:convert';

import 'package:chat_app/custom_widgets/custom_send_button.dart';
import 'package:chat_app/custom_widgets/loading.dart';
import 'package:chat_app/custom_widgets/message.dart';
import 'package:chat_app/interfaces/api.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/hive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chat extends StatefulWidget {
  static const id = 'CHAT';

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  String _me = '';
  String _token = '';
  dynamic _messages = [];
  bool _loading = true;
  bool _scrollToEnd = false;
  dynamic socketIO = null;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController(keepScrollOffset: false);

  void connectSocket() {
    print('connecting to socket.io...');
    IO.Socket socket = IO.io(
        'http://localhost:5000',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .build());
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  void populateAuth() async {
    final _tokensEncryptionBox =
        await MHive.getEncryptionBox(Constants.tokensEncryptionBoxName);
    var token = await MHive.getSecret(_tokensEncryptionBox, Constants.tokenKey);
    var res = await http.get(Uri.parse(IAPI.url + IAPI.getMe), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var resBody = jsonDecode(res.body);
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

  Future<void> getMessages() async {
    try {
      final _tokensEncryptionBox =
          await MHive.getEncryptionBox(Constants.tokensEncryptionBoxName);
      var token =
          await MHive.getSecret(_tokensEncryptionBox, Constants.tokenKey);
      var res =
          await http.get(Uri.parse(IAPI.url + IAPI.getMessages), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var resBody = jsonDecode(res.body);
      if (resBody['success']) {
        setState(() {
          _messages = resBody['data']['messages'];
          _loading = false;
          _scrollToEnd = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    populateAuth();
    getMessages();
    connectSocket();
  }

  Future<void> sendMessage() async {
    String message = messageController.text;
    if (message.length > 0) {
      var res = await http.post(Uri.parse(IAPI.url + IAPI.addMessage),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $_token',
          },
          body: jsonEncode({"content": message}));
      var resBody = jsonDecode(res.body);
      if (resBody['success']) {
        getMessages();
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback(((_) {
      if (_scrollToEnd) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    }));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Material(
          color: Colors.black,
          child: InkWell(
            child: Hero(
                tag: 'logo',
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/black.jpg',
                  ),
                  radius: 70.0,
                  backgroundColor: Colors.black,
                )),
            onTap: () {},
          ),
        ),
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
      body: _loading
          ? Loading()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                      controller: scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        String messageContent = _messages[index]['content'];
                        String messageUsername =
                            _messages[index]['User']['username'];
                        bool me = messageUsername == _me;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Message(
                              username: messageUsername,
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
                            decoration:
                                InputDecoration(hintText: 'Start typing...'),
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
