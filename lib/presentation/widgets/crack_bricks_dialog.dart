import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenwordflutter/data/model/treasure_progress.dart';

import '../../logic/blocs/treasure/treasure_bloc.dart';
import '../../logic/blocs/treasure/treasure_state.dart';
import '../pages/treasure_page.dart';

class CrackBricksDialog extends StatefulWidget {
  const CrackBricksDialog({super.key});

  @override
  State<CrackBricksDialog> createState() => _CrackBricksDialogState();
}

class _CrackBricksDialogState extends State<CrackBricksDialog> {
  bool _bricksCracked = false;
  bool _hasCracked = false; // Track if bricks have already cracked

  @override
  void initState() {
    super.initState();

    final treasureBloc = context.read<TreasureBloc>();
    final progress = treasureBloc.state;

    if (progress is TreasureLoaded) {
      final currentSet = progress.progress.setsCompleted;
      final alreadyCracked = progress.progress.lastCrackedSet >= currentSet;

      if (alreadyCracked) {
        // Go directly to TreasurePage
        Future.microtask(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const TreasurePage()),
          );
        });
        return;
      }

      // Start cracking animation
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _bricksCracked = true;
        });

        Future.delayed(const Duration(seconds: 2), () async {
          if (mounted && !_hasCracked) {
            setState(() {
              _hasCracked = true;
            });

            // 🧠 Save that the current set has now been cracked
            final updated = progress.progress;
            updated.lastCrackedSet = currentSet;
            await treasureBloc.isar.writeTxn(
              () => treasureBloc.isar.treasureProgress.put(updated),
            );

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const TreasurePage()),
            );
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<TreasureBloc>().state;

    // Get the index of the vase to be shown
    int vaseIndex =
        progress is TreasureLoaded && progress.progress.vaseIndices.isNotEmpty
            ? progress.progress.vaseIndices.last
            : -1;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Fade out bricks only if they haven't cracked yet
            AnimatedOpacity(
              opacity: _bricksCracked ? 0.0 : 1.0,
              duration: const Duration(seconds: 1),
              child: Image.asset('assets/images/bricks.png', height: 200),
            ),

            // Show vase AFTER bricks are cracked
            if (_bricksCracked && vaseIndex != -1)
              Image.asset(
                'assets/images/vases/vase-${vaseIndex + 1}.png',
                height: 200,
              ),

            // Animate hammer strike
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              top: _bricksCracked ? -100 : 0,
              child: Image.asset('assets/images/hammer.png', height: 100),
            ),
          ],
        ),
      ),
    );
  }
}
