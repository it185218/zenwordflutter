import 'package:flutter/material.dart';
import '../../core/utils/color_library.dart';
import '../../core/utils/scale_animation_helper.dart';

class TreasureContainer extends StatefulWidget {
  final VoidCallback? onTap;

  const TreasureContainer({super.key, this.onTap});

  @override
  State<TreasureContainer> createState() => _TreasureContainerState();
}

class _TreasureContainerState extends State<TreasureContainer> {
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
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorLibrary.button,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/images/chest.png'),
            ),
          ),
        ),
      ],
    );
  }
}
