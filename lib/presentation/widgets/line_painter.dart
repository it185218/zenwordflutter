import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';

class LinePainter extends CustomPainter {
  final List<Offset> points;
  final Offset? currentTouch;

  LinePainter({required this.points, this.currentTouch});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint =
        Paint()
          ..color = ColorLibrary.letterContainer
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    if (currentTouch != null && points.isNotEmpty) {
      canvas.drawLine(points.last, currentTouch!, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
