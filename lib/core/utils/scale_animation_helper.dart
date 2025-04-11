import 'package:flutter/material.dart';

class AnimationHelper {
  static void onTapDown(
    TapDownDetails details,
    ValueChanged<double> onScaleChanged,
  ) {
    onScaleChanged(0.9);
  }

  static void onTapUp(
    TapUpDetails details,
    ValueChanged<double> onScaleChanged,
  ) {
    onScaleChanged(1.0);
  }

  static void onTapCancel(ValueChanged<double> onScaleChanged) {
    onScaleChanged(1.0);
  }
}
