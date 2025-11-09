import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(color: ColorLibrary.background)),
        // Background image
        Positioned.fill(
          child: Image.asset('assets/images/ruins_bg.jpg', fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(color: ColorLibrary.backgroundOverlay),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: child,
          floatingActionButton: floatingActionButton,
        ),
      ],
    );
  }
}
