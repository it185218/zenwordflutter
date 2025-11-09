import 'package:flutter/material.dart';
import '../../core/utils/color_library.dart';
import '../../core/utils/scale_animation_helper.dart';

class HintContainer extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const HintContainer({super.key, required this.icon, this.onTap});

  @override
  State<HintContainer> createState() => _HintContainerState();
}

class _HintContainerState extends State<HintContainer> {
  double _scale = 1.0;

  void _handleTap() {
    widget.onTap?.call();
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
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: ColorLibrary.button,
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
