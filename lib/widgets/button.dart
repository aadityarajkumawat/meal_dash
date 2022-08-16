import 'package:flutter/material.dart';

typedef AsyncCallback = Future<void> Function(BuildContext context);

class ButtonProps {
  late String text;
  late AsyncCallback onPressed;

  double top = 0;
  double left = 0;
  double right = 0;
  double bottom = 0;

  ButtonProps({
    required this.onPressed,
    required this.text,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });
}

class Button extends StatelessWidget {
  const Button({Key? key, required this.buttonProps}) : super(key: key);

  final ButtonProps buttonProps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        buttonProps.left,
        buttonProps.top,
        buttonProps.right,
        buttonProps.bottom,
      ),
      child: ElevatedButton(
        onPressed: () => buttonProps.onPressed(context),
        style: ElevatedButton.styleFrom(
            primary: Colors.black, minimumSize: const Size.fromHeight(50)),
        child: Text(buttonProps.text),
      ),
    );
  }
}
