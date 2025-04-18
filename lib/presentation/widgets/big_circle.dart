import 'package:flutter/material.dart';

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
            center: const Alignment(-0.4, -0.4),
            radius: 0.95,
            colors: [
              Color.fromRGBO(255, 255, 255, 0.35),
              Color.fromARGB(120, 156, 122, 80),
              Color.fromARGB(153, 156, 122, 80),
              Color.fromARGB(100, 60, 40, 20),
            ],
            stops: [0.0, 0.4, 0.75, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(78, 0, 0, 0),
              offset: Offset(6, 6),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
