import 'package:flutter/material.dart';

import '../widgets/background_scaffold.dart';
import 'game_page.dart';

class LevelCompletePage extends StatelessWidget {
  final int level;
  const LevelCompletePage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final nextLevel = level + 1;

    return AppScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Level $level Completed',
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 16),
            Text(
              'Next: Level $nextLevel',
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => GamePage(level: nextLevel)),
                );
              },
              child: const Text('Next Level'),
            ),
          ],
        ),
      ),
    );
  }
}
