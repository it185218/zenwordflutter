import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:zenwordflutter/data/model/saved_game.dart';
import '../../core/utils/circular_position.dart';
import '../../logic/blocs/coin/coin_bloc.dart';
import '../../logic/blocs/coin/coin_event.dart';
import '../../logic/blocs/coin/coin_state.dart';
import '../../logic/blocs/game/game_bloc.dart';
import '../../logic/blocs/game/game_event.dart';
import '../../logic/blocs/game/game_state.dart';
import '../../logic/blocs/level/level_bloc.dart';
import '../../logic/blocs/level/level_event.dart';
import '../../logic/blocs/treasure/treasure_bloc.dart';
import '../../logic/blocs/treasure/treasure_event.dart';
import '../../logic/blocs/treasure/treasure_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/big_circle.dart';
import '../widgets/current_word_display.dart';
import '../widgets/found_extras_dialog.dart';
import '../widgets/hint_container.dart';
import '../widgets/letter_circle.dart';
import '../widgets/line_painter.dart';
import '../widgets/perfect_popup.dart';
import '../widgets/tile_coins.dart';
import '../widgets/top_bar.dart';
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
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();

    stopwatch = Stopwatch()..start(); // Start timer

    Future.microtask(() {
      final allowMultipleSolutions =
          context.read<GameBloc>().state.allowMultipleSolutions;
      context.read<TreasureBloc>().add(LoadTreasure());
      context.read<GameBloc>().add(
        GameStarted(
          level: widget.level,
          allowMultipleSolutions: allowMultipleSolutions,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<CoinBloc, CoinState>(
          builder: (context, state) {
            return TopBar(
              title: 'Επίπεδο ${widget.level}',
              coinText: '${state.coins}',
            );
          },
        ),
      ),

      child: BlocListener<GameBloc, GameState>(
        listenWhen: (prev, curr) => prev.validWords != curr.validWords,
        listener: (context, state) {
          final treasureBloc = context.read<TreasureBloc>();
          final treasureState = treasureBloc.state;

          if (state.validWords.isNotEmpty &&
              treasureState is TreasureLoaded &&
              treasureState.progress.currentLevelWithIcon != widget.level &&
              widget.level % 2 == 0 &&
              widget.level >= 6) {
            treasureBloc.add(
              GenerateCollectible(
                level: widget.level,
                validWords: state.validWords,
                foundWords: state.foundWords,
              ),
            );
          }
        },

        child: BlocListener<GameBloc, GameState>(
          listenWhen:
              (prev, curr) => prev.foundWords.length != curr.foundWords.length,
          listener: (context, state) {
            final allFound =
                state.validWords.toSet().difference(state.foundWords).isEmpty;

            final treasureState = context.read<TreasureBloc>().state;
            if (treasureState is TreasureLoaded) {
              final collectibleWord =
                  treasureState.progress.wordWithCollectible;
              if (collectibleWord != null &&
                  state.foundWords.contains(collectibleWord)) {
                context.read<TreasureBloc>().add(
                  CollectTreasure(word: collectibleWord),
                );
              }
            }

            if (allFound) {
              stopwatch.stop(); // Stop timer

              showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.transparent,
                builder: (context) {
                  return Stack(children: [const PerfectPopup()]);
                },
              );

              final currentLevel = context.read<LevelBloc>().state.currentLevel;

              final isar = Isar.getInstance();
              isar!.writeTxn(() async {
                final saved =
                    await isar.savedGames
                        .filter()
                        .levelEqualTo(currentLevel)
                        .findFirst();
                if (saved != null) {
                  await isar.savedGames.delete(saved.id);
                }
              });

              context.read<LevelBloc>().add(
                CompleteLevel(
                  level: currentLevel,
                  durationSeconds: stopwatch.elapsed.inSeconds,
                  foundWords: state.foundWords,
                  validWords: state.validWords,
                ),
              );

              Future.delayed(const Duration(milliseconds: 1000), () {
                context.read<GameBloc>().add(ResetGameState());

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
                return const Center();
              }

              final treasureBloc = context.read<TreasureBloc>();
              final treasureState = treasureBloc.state;
              if (treasureState is TreasureInitial &&
                  state.validWords.isNotEmpty) {
                treasureBloc.add(
                  GenerateCollectible(
                    level: widget.level,
                    validWords: state.validWords,
                    foundWords: state.foundWords,
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: Center(
                        child: WordTileGrid(
                          validWords: state.validWords,
                          foundWords: state.foundWords,
                          revealedLetters: state.revealedLetters,
                          hintRevealedLetters: state.hintRevealedLetters,
                          wordWithCollectible:
                              treasureState is TreasureLoaded
                                  ? treasureState.progress.wordWithCollectible
                                  : null,
                          isCollectibleCollected:
                              treasureState is TreasureLoaded &&
                              treasureState.progress.wordWithCollectible !=
                                  null &&
                              state.foundWords.contains(
                                treasureState.progress.wordWithCollectible!,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  CurrentWordDisplay(
                    currentWord:
                        state.selectedIndices
                            .map((i) => state.letters[i])
                            .join(),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      SizedBox(
                        height: 250,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 16,
                            top: 16,
                            bottom: 16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              HintContainer(
                                icon: Icons.shuffle_rounded,
                                onTap: () {
                                  context.read<GameBloc>().add(
                                    GameShuffleLetters(),
                                  );
                                },
                              ),

                              HintContainer(
                                icon: Icons.star_outline_rounded,
                                onTap: () {
                                  showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel: "Extras",
                                    transitionDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    pageBuilder: (_, __, ___) {
                                      return const FoundExtrasDialog();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          height: 300,
                          alignment: Alignment.center,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final circleCenter = Offset(
                                constraints.maxWidth / 2,
                                constraints.maxHeight / 2,
                              );
                              final safeRadius = radius - circleSize / 2;
                              final positions = calculateCircularPositions(
                                center: circleCenter,
                                count: letters.length,
                                radius: safeRadius,
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
                                    BigCircle(
                                      radius: radius,
                                      circleSize: circleSize,
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
                                      final isSelected = state.selectedIndices
                                          .contains(i);
                                      final id = state.letterIds[i];

                                      return AnimatedPositioned(
                                        key: ValueKey(id),
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
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
                      ),

                      SizedBox(
                        height: 250,
                        child: Container(
                          padding: EdgeInsets.only(
                            right: 16,
                            top: 16,
                            bottom: 16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topCenter,
                                children: [
                                  Column(
                                    children: [
                                      HintContainer(
                                        icon: Icons.emoji_objects_outlined,
                                        onTap: () {
                                          final coinState =
                                              context.read<CoinBloc>().state;

                                          if (coinState.coins > 80) {
                                            context.read<CoinBloc>().add(
                                              SpendCoins(80),
                                            );
                                            context.read<GameBloc>().add(
                                              GameUseHintLetter(),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Δεν υπάρχουν αρκετά νομίσματα!",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: -10,
                                    child: TileCoins(
                                      image: 'assets/images/coin.png',
                                      text: '80',
                                    ),
                                  ),
                                ],
                              ),
                              // HintContainer(
                              //   icon: Icons.money,
                              //   onTap: () {
                              //     context.read<CoinBloc>().add(AddCoins(100));
                              //   },
                              // ),
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topCenter,
                                children: [
                                  Column(
                                    children: [
                                      HintContainer(
                                        icon: Icons.rocket_launch_outlined,
                                        onTap: () {
                                          final coinState =
                                              context.read<CoinBloc>().state;

                                          if (coinState.coins > 240) {
                                            context.read<CoinBloc>().add(
                                              SpendCoins(240),
                                            );
                                            context.read<GameBloc>().add(
                                              GameUseHintFirstLetters(),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Δεν υπάρχουν αρκετά νομίσματα!",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: -10,
                                    child: TileCoins(
                                      image: 'assets/images/coin.png',
                                      text: '120',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
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
