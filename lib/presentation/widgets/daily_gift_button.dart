import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';
import '../../core/utils/scale_animation_helper.dart';

class DailyGiftButton extends StatefulWidget {
  final VoidCallback? onTap;

  const DailyGiftButton({super.key, this.onTap});

  @override
  State<DailyGiftButton> createState() => _DailyGiftButtonState();
}

class _DailyGiftButtonState extends State<DailyGiftButton> {
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
                Icons.card_giftcard,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}