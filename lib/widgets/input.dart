import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class InputDetails {
  late String hintText;
  late TextEditingController textController;

  bool secureInput = false;
  bool enableSuggestions = true;
  bool autocorrect = false;

  InputDetails({
    required this.hintText,
    required this.textController,
    this.secureInput = false,
    this.enableSuggestions = true,
    this.autocorrect = false,
  });
}

class Input extends StatelessWidget {
  const Input({Key? key, required this.inputProps}) : super(key: key);

  final InputDetails inputProps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: SizedBox(
        child: TextField(
          obscureText: inputProps.secureInput,
          controller: inputProps.textController,
          enableSuggestions: inputProps.enableSuggestions,
          autocorrect: inputProps.autocorrect,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: inputProps.hintText,
            contentPadding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
