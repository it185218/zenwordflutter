import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/circular_position.dart';
import '../../logic/blocs/coin/coin_bloc.dart';
import '../../logic/blocs/coin/coin_event.dart';
import '../../logic/blocs/coin/coin_state.dart';
import '../../logic/blocs/game/game_bloc.dart';
import '../../logic/blocs/game/game_event.dart';
import '../../logic/blocs/game/game_state.dart';
import '../../logic/blocs/level/level_bloc.dart';
import '../../logic/blocs/level/level_event.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/current_word_display.dart';
import '../widgets/letter_circle.dart';
import '../widgets/line_painter.dart';
import '../widgets/word_tile_grid.dart';
import 'level_complete_page.dart';

class GamePage extends StatefulWidget {
  final int level;

  const GamePage({super.key, required this.level});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final double radius = 100.0;
  final double circleSize = 50.0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GameBloc>().add(GameStarted(level: widget.level));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Level ${widget.level}'),
            BlocBuilder<CoinBloc, CoinState>(
              builder: (context, state) {
                return Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${state.coins}'),
                  ],
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      child: BlocListener<GameBloc, GameState>(
        listenWhen:
            (prev, curr) => prev.foundWords.length != curr.foundWords.length,
        listener: (context, state) {
          if (state.validWords.toSet().difference(state.foundWords).isEmpty) {
            final currentLevel = context.read<LevelBloc>().state.currentLevel;

            context.read<CoinBloc>().add(AddCoins(80));
            context.read<LevelBloc>().add(CompleteLevel(currentLevel));

            Future.delayed(const Duration(milliseconds: 400), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LevelCompletePage(level: currentLevel),
                ),
              );
            });
          }
        },
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            final letters = state.letters;
            if (letters.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: WordTileGrid(
                      validWords: state.validWords,
                      foundWords: state.foundWords,
                    ),
                  ),
                ),
                const Spacer(),
                CurrentWordDisplay(
                  currentWord:
                      state.selectedIndices.map((i) => state.letters[i]).join(),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final circleCenter = Offset(
                        constraints.maxWidth / 2,
                        constraints.maxHeight / 2,
                      );
                      final positions = calculateCircularPositions(
                        center: circleCenter,
                        count: letters.length,
                        radius: radius - circleSize / 4,
                      );
                      return GestureDetector(
                        onPanStart: (details) {
                          _handleTouch(
                            context,
                            details.localPosition,
                            positions,
                          );
                        },
                        onPanUpdate: (details) {
                          context.read<GameBloc>().add(
                            GameTouchUpdate(details.localPosition),
                          );
                          _handleTouch(
                            context,
                            details.localPosition,
                            positions,
                          );
                        },
                        onPanEnd: (_) {
                          context.read<GameBloc>().add(GameTouchEnd());
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                width: radius * 2 + circleSize,
                                height: radius * 2 + circleSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 8,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CustomPaint(
                              size: Size.infinite,
                              painter: LinePainter(
                                points:
                                    state.selectedIndices
                                        .map((i) => positions[i])
                                        .toList(),
                                currentTouch: state.currentTouch,
                              ),
                            ),
                            ...List.generate(letters.length, (i) {
                              final pos = positions[i];
                              final isSelected = state.selectedIndices.contains(
                                i,
                              );
                              return Positioned(
                                left: pos.dx - circleSize / 2,
                                top: pos.dy - circleSize / 2,
                                child: LetterCircle(
                                  letter: letters[i],
                                  isSelected: isSelected,
                                  size: circleSize,
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleTouch(
    BuildContext context,
    Offset touchPoint,
    List<Offset> positions,
  ) {
    final bloc = context.read<GameBloc>();
    final state = bloc.state;
    final selected = state.selectedIndices;

    for (int i = 0; i < positions.length; i++) {
      final distance = (touchPoint - positions[i]).distance;
      final alreadySelected = selected.contains(i);

      if (distance < circleSize / 2) {
        if (!alreadySelected) {
          bloc.add(GameLetterSelected(i));
        } else if (selected.length > 1 && i == selected[selected.length - 2]) {
          bloc.add(GameUndoLastSelection());
        }
        break;
      }
    }
  }
}
