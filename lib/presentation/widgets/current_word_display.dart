import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';

class CurrentWordDisplay extends StatelessWidget {
  final String currentWord;

  const CurrentWordDisplay({super.key, required this.currentWord});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: currentWord.isEmpty ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: ColorLibrary.letterContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          currentWord,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: ColorLibrary.letterSelected,
          ),
        ),
      ),
    );
  }
}
