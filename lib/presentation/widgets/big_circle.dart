import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';

class BigCircle extends StatelessWidget {
  final double radius;
  final double circleSize;

  const BigCircle({super.key, required this.radius, required this.circleSize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius * 2 + circleSize,
        height: radius * 2 + circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.3), // light from top-left
            radius: 0.8,
            colors: [
              Color.fromRGBO(163, 130, 89, 0.4),
              ColorLibrary.roundContainer,
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(78, 0, 0, 0),
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}
