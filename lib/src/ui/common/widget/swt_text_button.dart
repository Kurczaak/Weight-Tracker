import 'package:flutter/material.dart';

class SWTTextButton extends StatelessWidget {
  const SWTTextButton({
    required this.title,
    required this.onPressed,
    super.key,
  });

  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
