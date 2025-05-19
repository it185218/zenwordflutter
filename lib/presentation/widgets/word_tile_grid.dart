import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/color_library.dart';
import '../../logic/blocs/coin/coin_bloc.dart';
import '../../logic/blocs/coin/coin_event.dart';
import '../../logic/blocs/treasure/treasure_bloc.dart';
import '../../logic/blocs/treasure/treasure_state.dart';

class WordTileGrid extends StatefulWidget {
  final List<String> validWords;
  final Set<String> foundWords;
  final Map<String, Set<int>> revealedLetters;
  final Map<String, Set<int>> hintRevealedLetters;
  final String? wordWithCollectible;
  final bool isCollectibleCollected;

  const WordTileGrid({
    super.key,
    required this.validWords,
    required this.foundWords,
    this.revealedLetters = const {},
    this.hintRevealedLetters = const {},
    this.wordWithCollectible,
    this.isCollectibleCollected = false,
  });

  @override
  State<WordTileGrid> createState() => _WordTileGridState();
}

class _WordTileGridState extends State<WordTileGrid> {
  final Set<String> rewardedWords = {};

  @override
  void didUpdateWidget(covariant WordTileGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    for (final word in widget.validWords) {
      final wasFound = oldWidget.foundWords.contains(word);
      final isNowFound = widget.foundWords.contains(word);

      if (!wasFound && isNowFound && !rewardedWords.contains(word)) {
        final revealed = widget.revealedLetters[word];
        if (revealed != null && revealed.isNotEmpty) {
          final coinTiles = word.length - revealed.length;
          if (coinTiles > 0) {
            context.read<CoinBloc>().add(AddCoins(coinTiles));
            rewardedWords.add(word);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const baseTileSize = 48.0;
        const minTileSize = 42.0;

        final totalWords = widget.validWords.length;

        // Estimate columns and rows
        final columns = (totalWords > 10) ? 2 : 1;
        final rowsPerColumn = (totalWords / columns).ceil();

        final availableHeight = constraints.maxHeight;
        double bestTileSize = availableHeight / rowsPerColumn;

        if (columns == 2) {
          bestTileSize = minTileSize;
        } else if (bestTileSize > baseTileSize) {
          bestTileSize = baseTileSize;
        } else if (bestTileSize < minTileSize) {
          bestTileSize = minTileSize;
        }

        final fontSize = bestTileSize * 0.5;

        final columnWidgets = <Widget>[];
        final wordsToDisplay = widget.validWords;

        for (int col = 0; col < columns; col++) {
          final start = col * rowsPerColumn;
          final end = (start + rowsPerColumn).clamp(0, wordsToDisplay.length);
          final words = wordsToDisplay.sublist(start, end);

          columnWidgets.add(
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  columns == 1
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
              children:
                  words.map((word) {
                    final isFound = widget.foundWords.contains(word);
                    final revealed = {
                      ...?widget.revealedLetters[word],
                      ...?widget.hintRevealedLetters[word],
                    };

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(word.length, (i) {
                        final revealedSet = widget.revealedLetters[word] ?? {};
                        final hintSet = widget.hintRevealedLetters[word] ?? {};

                        final isRewardedReveal =
                            revealedSet.length == 1 &&
                            revealedSet.contains(0) &&
                            !isFound &&
                            !hintSet.contains(0);

                        final showLetter = isFound || revealed.contains(i);
                        final isCoin =
                            isRewardedReveal && i != 0 ||
                            (revealedSet.contains(i) && !hintSet.contains(i));

                        final treasureState =
                            context.watch<TreasureBloc>().state;
                        int? collectibleIndex;

                        if (treasureState is TreasureLoaded &&
                            treasureState.progress.wordWithCollectible ==
                                word) {
                          collectibleIndex =
                              treasureState.progress.collectibleTileIndex;
                        }

                        final showCollectible =
                            collectibleIndex != null &&
                            i == collectibleIndex &&
                            word == widget.wordWithCollectible &&
                            !widget.isCollectibleCollected &&
                            !widget.foundWords.contains(word) &&
                            !isCoin;

                        return Container(
                          margin: const EdgeInsets.all(2),
                          width: bestTileSize,
                          height: bestTileSize,
                          decoration: BoxDecoration(
                            color:
                                showLetter
                                    ? ColorLibrary.gridFilled
                                    : ColorLibrary.gridEmpty,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child:
                              showLetter
                                  ? Text(
                                    word[i],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                  : isCoin
                                  ? Image.asset(
                                    'assets/images/coin.png',
                                    width: fontSize,
                                  )
                                  : showCollectible
                                  ? Image.asset(
                                    'assets/images/bricks.png',
                                    width: fontSize,
                                  )
                                  : const SizedBox.shrink(),
                        );
                      }),
                    );
                  }).toList(),
            ),
          );
        }

        return Wrap(
          alignment: columns == 1 ? WrapAlignment.center : WrapAlignment.start,
          spacing: 16,
          runSpacing: 8,
          children: columnWidgets,
        );
      },
    );
  }
}
