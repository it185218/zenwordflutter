// perfect_popup.dart
import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';

class PerfectPopup extends StatefulWidget {
  const PerfectPopup({Key? key}) : super(key: key);

  @override
  _PerfectPopupState createState() => _PerfectPopupState();
}

class _PerfectPopupState extends State<PerfectPopup>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      )
      ..forward().then((_) {
        if (mounted) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              _controller.reverse();
            }
          });
        }
      });

    _opacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
          child: Text(
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
