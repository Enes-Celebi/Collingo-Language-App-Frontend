import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? fontSize; 

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color, 
    this.fontSize, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), 
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: color ?? Theme.of(context).colorScheme.primary, 
              width: 2, // Border width
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), 
            ),
            padding: const EdgeInsets.symmetric(vertical: 18), 
            backgroundColor: Colors.transparent, 
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: color ?? Theme.of(context).colorScheme.primary, 
              fontSize: fontSize ?? 16,
            ),
          ),
        ),
      ),
    );
  }
}