import 'package:flutter/material.dart';
import 'package:collingo/presentation/auth/components/secondary_button.dart';

void showCustomDialog(
  BuildContext context,
  String message,
  Color color,
  VoidCallback onOkPressed, 
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 3,
          ),
        ),
        title: Center(
          child: Text(
            "Log In",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Container(
          height: 100,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: SecondaryButton(
              text: "OK",
              onPressed: () {
                onOkPressed(); 
                Navigator.of(context).pop(); 
              },
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ],
      );
    },
  );
}