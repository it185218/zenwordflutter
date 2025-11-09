import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';

// Perfect message after finding all words
class PerfectPopup extends StatefulWidget {
  const PerfectPopup({super.key});

  @override
  State<PerfectPopup> createState() => _PerfectPopupState();
}

class _PerfectPopupState extends State<PerfectPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start fade-in, wait a second, then pop the dialog
    _controller.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        Navigator.of(context).pop(); // auto dismiss
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
    _controller.dispose();
    super.dispose();
  }
}
