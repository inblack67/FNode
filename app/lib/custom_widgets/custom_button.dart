import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String title;

  CustomButton({required this.title, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Material(
          elevation: 6.0,
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: callback,
            child: Text(title),
            color: Colors.red,
            minWidth: 200.0,
            height: 50.0,
          ),
        ),
      ),
    );
  }
}
