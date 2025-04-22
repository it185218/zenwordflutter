import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenwordflutter/presentation/pages/treasure_page.dart';

import '../../core/utils/color_library.dart';
import '../../logic/blocs/coin/coin_bloc.dart';
import '../../logic/blocs/coin/coin_event.dart';
import '../../logic/blocs/coin/coin_state.dart';
import '../../logic/blocs/level/level_bloc.dart';
import '../../logic/blocs/treasure/treasure_bloc.dart';
import '../../logic/blocs/treasure/treasure_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/crack_bricks_dialog.dart';
import '../widgets/level_button.dart';
import '../widgets/top_bar.dart';
import '../widgets/treasure_container.dart';
import 'game_page.dart';

class LevelCompletePage extends StatefulWidget {
  final int level;
  const LevelCompletePage({super.key, required this.level});

  @override
  State<LevelCompletePage> createState() => _LevelCompletePageState();
}

class _LevelCompletePageState extends State<LevelCompletePage>
    with SingleTickerProviderStateMixin {
  bool showReward = false;
  bool rewardGiven = false;

  @override
  void initState() {
    super.initState();
    final completed = context.read<LevelBloc>().state.completedCount;
    final shouldReward = completed % 10 == 0;

    if (shouldReward) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          showReward = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (!rewardGiven && mounted) {
            context.read<CoinBloc>().add(AddCoins(50));
            setState(() {
              rewardGiven = true;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nextLevel = widget.level + 1;
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12, top: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TreasureContainer(
                  onTap: () async {
                    // Check if a set is completed in TreasureBloc
                    final progress = context.read<TreasureBloc>().state;
                    final isSetCompleted =
                        progress is TreasureLoaded &&
                        progress.progress.setsCompleted > 0;

                    // Navigate to the appropriate page based on set completion
                    if (isSetCompleted) {
                      // Show CrackBricksDialog if set is completed
                      await showDialog(
                        context: context,
                        builder: (context) => CrackBricksDialog(),
                      );
                    } else {
                      // Show TreasurePage if set is not completed
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => TreasurePage()),
                      );
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 80),

            const Text(
              'Λεξόσφαιρα',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Level Completed',
              style: TextStyle(
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
                      color: ColorLibrary.progress,
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

            // Reward animation
            if (shouldReward)
              AnimatedOpacity(
                opacity: showReward ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: ColorLibrary.coinRewardedCpntainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '50 Coins Rewarded!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Level button only if no reward is pending
            if (!shouldReward || rewardGiven)
              LevelButton(
                text: 'Level $nextLevel',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => GamePage(level: nextLevel),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
