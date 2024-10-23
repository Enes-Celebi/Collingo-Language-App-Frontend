import 'package:flutter/material.dart';

class CodeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const CodeTextField({
    Key? key,
    required this.controller,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Theme.of(context).colorScheme.onSecondary;

    return Center(
      child: Container(
        width: 130, 
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            labelText: null, 
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), 
              borderSide: BorderSide(color: borderColor), 
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), 
              borderSide: BorderSide(color: borderColor, width: 2), 
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), 
              borderSide: BorderSide(color: borderColor), 
            ),
            filled: false, 
            isDense: true, 
            counterText: '', 
          ),
          style: TextStyle(
            fontSize: 30,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          cursorColor: Colors.transparent,
          cursorWidth: 0, 
          onChanged: (value) {
            if (value.length > 6) {
              controller.text = value.substring(0, 6);
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          },
        ),
      ),
    );
  }
}
