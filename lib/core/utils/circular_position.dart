import 'dart:math';
import 'package:flutter/material.dart';

List<Offset> calculateCircularPositions({
  required Offset center,
  required int count,
  required double radius,
}) {
  return List.generate(count, (i) {
    final angle = (2 * pi * i) / count;
    return Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );
  });
}
