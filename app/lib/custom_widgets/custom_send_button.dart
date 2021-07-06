import 'package:flutter/material.dart';

class CustomSendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  CustomSendButton({required this.text, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: callback,
        child: Text(text),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
      ),
    );
  }
}
