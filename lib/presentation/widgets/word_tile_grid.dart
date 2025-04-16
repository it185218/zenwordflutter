import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/coin/coin_bloc.dart';
import '../../logic/blocs/coin/coin_event.dart';

class WordTileGrid extends StatefulWidget {
  final List<String> validWords;
  final Set<String> foundWords;
  final Map<String, Set<int>> revealedLetters;

  const WordTileGrid({
    super.key,
    required this.validWords,
    required this.foundWords,
    this.revealedLetters = const {},
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

        // Word qualifies for coin reward only if it had revealed first letter + coin icons
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
        final maxHeight =
            constraints.hasBoundedHeight
                ? constraints.maxHeight
                : MediaQuery.of(context).size.height * 0.6;

        const tileSpacing = 8.0;
        const baseTileSize = 40.0;
        const minTileSize = 28.0;

        double bestTileSize = baseTileSize;
        int maxWordsPerColumn = 1;
        int columns = 1;

        for (
          double tileSize = baseTileSize;
          tileSize >= minTileSize;
          tileSize -= 2
        ) {
          final tileWithSpacing = tileSize + tileSpacing;
          final wordsPerColumn = (maxHeight / tileWithSpacing).floor();

          if (wordsPerColumn == 0) continue;

          final neededColumns =
              (widget.validWords.length / wordsPerColumn).ceil();

          if (neededColumns * (tileSize * 6) <= constraints.maxWidth) {
            bestTileSize = tileSize;
            maxWordsPerColumn = wordsPerColumn;
            columns = neededColumns;
            break;
          }
        }

        final fontSize = bestTileSize * 0.5;

        final columnWidgets = <Widget>[];
        for (int col = 0; col < columns; col++) {
          final start = col * maxWordsPerColumn;
          final end = (start + maxWordsPerColumn).clamp(
            0,
            widget.validWords.length,
          );
          final words = widget.validWords.sublist(start, end);

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
                    final revealed = widget.revealedLetters[word] ?? {};

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(word.length, (i) {
                        final showLetter = isFound || revealed.contains(i);

                        return Container(
                          margin: const EdgeInsets.all(2),
                          width: bestTileSize,
                          height: bestTileSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child:
                              showLetter
                                  ? Text(
                                    word[i],
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                  : (revealed.isNotEmpty &&
                                      !revealed.contains(i))
                                  ? Icon(
                                    Icons.monetization_on,
                                    size: fontSize,
                                    color: Colors.amber[700],
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
