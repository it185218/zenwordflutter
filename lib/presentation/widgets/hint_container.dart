import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';

class HintContainer extends StatelessWidget {
  final IconData icon;

  const HintContainer({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: ColorLibrary.button,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
