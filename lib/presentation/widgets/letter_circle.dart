import 'package:flutter/material.dart';

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
        color: isSelected ? Colors.blueAccent : Colors.transparent,
        border: Border.all(
          color: isSelected ? Colors.blueAccent : Colors.transparent,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
