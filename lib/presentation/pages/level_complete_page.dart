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

// This screen provides visual feedback for completing a level,
// potentially shows a reward for every 10 levels completed,
// and allows the user to proceed to the next level.
class LevelCompletePage extends StatefulWidget {
  // The level that was just completed.
  final int level;

  const LevelCompletePage({super.key, required this.level});

  @override
  State<LevelCompletePage> createState() => _LevelCompletePageState();
}

class _LevelCompletePageState extends State<LevelCompletePage>
    with SingleTickerProviderStateMixin {
  bool showReward = false; // Whether to show the reward message.
  bool rewardGiven =
      false; // Whether the coin reward has already been given to avoid duplicate rewards.
  bool showLevelButton =
      false; // Whether to show the button for proceeding to the next level.

  @override
  void initState() {
    super.initState();

    // Delay to ensure that game state is fully available
    Future.delayed(Duration(milliseconds: 200), () {
      if (!mounted) return;
      final completed = context.read<LevelBloc>().state.completedCount;
      final shouldReward = completed > 0 && completed % 10 == 0;

      // Check if a new collectible set has been completed and show a dialog
      final progress = context.read<TreasureBloc>().state;
      if (progress is TreasureLoaded) {
        final setsCompleted = progress.progress.setsCompleted;
        final lastCrackedSet = progress.progress.lastCrackedSet;

        final newSetCompleted = setsCompleted > lastCrackedSet;

        if (newSetCompleted) {
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (context) => const CrackBricksDialog(),
            );
          });
        }
      }

      // Show reward animation and give coins if eligible
      if (shouldReward) {
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          setState(() {
            showReward = true;
          });

          // After animation, give reward and show next level button
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted || rewardGiven) return;

            context.read<CoinBloc>().add(AddCoins(50));
            setState(() {
              rewardGiven = true;
              showLevelButton = true;
            });
          });
        });
      } else {
        // If no reward, show next level button immediately
        setState(() {
          showLevelButton = true;
        });
      }
    });
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
            // Treasure page navigation
            Padding(
              padding: EdgeInsets.only(left: 12, top: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TreasureContainer(
                  onTap: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => TreasurePage()),
                    );
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
              'Το επίπεδο ολοκληρώθηκε',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Progress bar toward 10-level reward
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

            // Reward message animation
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
                    'Επιβράβευση 50 νομισμάτων!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Button to go to the next level
            if (showLevelButton)
              LevelButton(
                text: 'Επίπεδο $nextLevel',
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
