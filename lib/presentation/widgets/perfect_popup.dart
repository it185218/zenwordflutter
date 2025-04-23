import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';

class PerfectPopup extends StatefulWidget {
  const PerfectPopup({super.key});

  @override
  State<PerfectPopup> createState() => _PerfectPopupState();
}

class _PerfectPopupState extends State<PerfectPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start the reverse fade after a short visible duration
    _dismissTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _controller.forward(); // play fade out
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: ColorLibrary.coinRewardedCpntainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Τέλειος!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
