import 'package:flutter/material.dart';

import 'game_page.dart';

class LevelCompletePage extends StatefulWidget {
  const LevelCompletePage({super.key});

  @override
  State<LevelCompletePage> createState() => _LevelCompleteState();
}

class _LevelCompleteState extends State<LevelCompletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Level Completed',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Start new level and return to GamePage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const GamePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Next Level'),
            ),
          ],
        ),
      ),
    );
  }
}
