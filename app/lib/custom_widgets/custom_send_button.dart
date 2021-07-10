import 'package:flutter/material.dart';

class CustomSendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  CustomSendButton({required this.text, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        onPressed: callback,
        child: Text(text),
        color: Colors.red,
        minWidth: 80.0,
        height: 50.0,
      ),
    );
  }
}
