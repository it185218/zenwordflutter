import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';
import '../../core/utils/scale_animation_helper.dart';

class LevelButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const LevelButton({super.key, required this.onPressed, required this.text});

  @override
  State<LevelButton> createState() => _LevelButtonState();
}

class _LevelButtonState extends State<LevelButton> {
  double _scale = 1.0;

  void _handleTap() {
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        AnimationHelper.onTapDown(details, (newScale) {
          setState(() => _scale = newScale);
        });
      },
      onTapUp: (details) {
        AnimationHelper.onTapUp(details, (newScale) {
          setState(() => _scale = newScale);
        });
        _handleTap();
      },
      onTapCancel: () {
        AnimationHelper.onTapCancel((newScale) {
          setState(() => _scale = newScale);
        });
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
          decoration: BoxDecoration(
            color: ColorLibrary.button,
            border: Border.all(color: ColorLibrary.buttonBorder, width: 2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            widget.text,
            style: const TextStyle(
              color: ColorLibrary.buttonText,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
