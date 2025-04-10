import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/coin/coin_bloc.dart';
import '../../logic/blocs/coin/coin_event.dart';
import '../../logic/blocs/level/level_bloc.dart';
import '../widgets/background_scaffold.dart';
import 'game_page.dart';

class LevelCompletePage extends StatelessWidget {
  final int level;
  const LevelCompletePage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final nextLevel = level + 1;
    final completed = context.select<LevelBloc, int>(
      (bloc) => bloc.state.completedCount,
    );

    final shouldReward = completed % 10 == 0;
    final progressTowardsReward = completed % 10;

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

            // Progress toward 10-level reward
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: progressTowardsReward / 10,
                    minHeight: 12,
                    backgroundColor: Colors.grey[300],
                    color: Colors.amber[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Levels Completed: $progressTowardsReward/10',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            if (shouldReward) ...[
              const Text(
                '🎉 You earned 50 coins!',
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<CoinBloc>().add(AddCoins(50));
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => GamePage(level: nextLevel),
                    ),
                  );
                },
                child: const Text('Claim & Next Level'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => GamePage(level: nextLevel),
                    ),
                  );
                },
                child: const Text('Next Level'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
