import 'package:flutter/material.dart';

class WordTileGrid extends StatelessWidget {
  final List<String> validWords;
  final Set<String> foundWords;

  const WordTileGrid({
    super.key,
    required this.validWords,
    required this.foundWords,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use fallback height if maxHeight is unbounded
        final maxHeight =
            constraints.hasBoundedHeight
                ? constraints.maxHeight
                : MediaQuery.of(context).size.height * 0.6; // fallback

        // Layout tuning constants
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

          if (wordsPerColumn == 0) continue; // skip if can't fit anything

          final neededColumns = (validWords.length / wordsPerColumn).ceil();

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
          final end = (start + maxWordsPerColumn).clamp(0, validWords.length);
          final words = validWords.sublist(start, end);

          columnWidgets.add(
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  columns == 1
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
              children:
                  words.map((word) {
                    final isFound = foundWords.contains(word);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(word.length, (i) {
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
                          child: Text(
                            isFound ? word[i] : '',
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
