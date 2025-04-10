import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';

class LevelButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const LevelButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorLibrary.button,
        foregroundColor: ColorLibrary.buttonText,
        elevation: 2,
        side: const BorderSide(color: ColorLibrary.buttonBorder, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
