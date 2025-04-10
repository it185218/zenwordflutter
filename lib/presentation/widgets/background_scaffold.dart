import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;

  const AppScaffold({
    Key? key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/puzzle_background.jpg', // Replace with your path
            fit: BoxFit.cover,
          ),
        ),
        // Optional dark overlay
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.2))),
        // Foreground Scaffold (transparent)
        Scaffold(
          backgroundColor: Colors.transparent, // Important!
          appBar: appBar,
          body: child,
          floatingActionButton: floatingActionButton,
        ),
      ],
    );
  }
}
