import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/game/game_bloc.dart';
import '../../logic/blocs/game/game_state.dart';

class FoundExtrasDialog extends StatelessWidget {
  const FoundExtrasDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: math.min(MediaQuery.of(context).size.width * 0.9, 350),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              final foundExtras = state.foundExtras;
              final totalGlobal = state.totalFoundExtras;

              // Calculate the progress toward the next reward
              final progressToNextReward =
                  (totalGlobal % 10); // Progress towards the next set of 10

              // Calculate the fraction of the next milestone (0/10, 1/10, etc.)
              final progress = progressToNextReward / 10.0;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Extra Words',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  // Progress indicator for the current cycle
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 8),

                  // Show progress to next reward
                  Text(
                    '$progressToNextReward / 10 extra words found for the next reward',
                  ),
                  const SizedBox(height: 16),

                  foundExtras.isEmpty
                      ? const Text("No extra words found yet.")
                      : Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children:
                            foundExtras
                                .map(
                                  (word) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      word,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Close"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
