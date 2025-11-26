import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';
import '../../core/utils/scale_animation_helper.dart';

class BrainmasterButton extends StatefulWidget {
  final VoidCallback? onTap;

  const BrainmasterButton({super.key, this.onTap});

  @override
  State<BrainmasterButton> createState() => _BrainmasterButtonState();
}

class _BrainmasterButtonState extends State<BrainmasterButton> {
  double _scale = 1.0;

  void _handleTap() {
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: ColorLibrary.button,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology_alt,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Brainmaster',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
