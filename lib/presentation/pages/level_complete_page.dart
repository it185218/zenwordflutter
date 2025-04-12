import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/color_library.dart';
import '../../logic/blocs/coin/coin_bloc.dart';
import '../../logic/blocs/coin/coin_event.dart';
import '../../logic/blocs/coin/coin_state.dart';
import '../../logic/blocs/level/level_bloc.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/level_button.dart';
import '../widgets/top_bar.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<CoinBloc, CoinState>(
          builder: (context, state) {
            return TopBar(coinText: '${state.coins}');
          },
        ),
      ),

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PUZZLE GAME',
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Level Completed',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: 16,
                    child: LinearProgressIndicator(
                      value: progressTowardsReward / 10,
                      minHeight: 12,
                      backgroundColor: ColorLibrary.button,
                      color: ColorLibrary.buttonBorder,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '$progressTowardsReward / 10',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 150),

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
            ],

            LevelButton(
              text: 'Level $nextLevel',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => GamePage(level: nextLevel)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
