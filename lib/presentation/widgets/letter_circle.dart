import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';

class LetterCircle extends StatelessWidget {
  final String letter;
  final bool isSelected;
  final double size;

  const LetterCircle({
    super.key,
    required this.letter,
    required this.isSelected,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? ColorLibrary.letterContainer : Colors.transparent,
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ColorLibrary.letter,
        ),
      ),
    );
  }
}
