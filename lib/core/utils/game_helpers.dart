import 'package:flutter/services.dart' show rootBundle;
import 'dart:math' show Random, max;

class GameHelpers {
  // Structure to hold level configuration
  static const Map<int, Map<String, dynamic>> levelRequirements = {
    1: {
      'totalTiles': [3, 6], // 1-2 words of 3 letters (3 to 6 letters)
      'subwords': [
        {
          'length': 3,
          'count': [1, 2],
        },
      ],
    },
    2: {
      'totalTiles': 10, // 2×3 + 1×4 = 10 letters
      'subwords': [
        {'length': 3, 'count': 2},
        {'length': 4, 'count': 1},
      ],
    },
    6: {
      'totalTiles': 18, // 2×3 + 3×4 = 6 + 12 = 18 letters
      'subwords': [
        {'length': 3, 'count': 2},
        {'length': 4, 'count': 3},
      ],
    },
    16: {
      'totalTiles': 20, // 1×3 + 3×4 + 1×5 = 3 + 12 + 5 = 20 letters
      'subwords': [
        {'length': 3, 'count': 1},
        {'length': 4, 'count': 3},
        {'length': 5, 'count': 1},
      ],
    },
    26: {
      'totalTiles': 25, // 1×3 + 3×4 + 2×5 = 3 + 12 + 10 = 25 letters
      'subwords': [
        {'length': 3, 'count': 1},
        {'length': 4, 'count': 3},
        {'length': 5, 'count': 2},
      ],
    },
    36: {
      'totalTiles': 20, // 1×4 + 2×5 + 1×6 = 4 + 10 + 6 = 20 letters
      'subwords': [
        {'length': 4, 'count': 1},
        {'length': 5, 'count': 2},
        {'length': 6, 'count': 1},
      ],
    },
    46: {
      'totalTiles': 26, // 1×4 + 2×5 + 2×6 = 4 + 10 + 12 = 26 letters
      'subwords': [
        {'length': 4, 'count': 1},
        {'length': 5, 'count': 2},
        {'length': 6, 'count': 2},
      ],
    },
    61: {
      'totalTiles': 24, // 1×5 + 2×6 + 1×7 = 5 + 12 + 7 = 24 letters
      'subwords': [
        {'length': 5, 'count': 1},
        {'length': 6, 'count': 2},
        {'length': 7, 'count': 1},
      ],
    },
  };

  // Load dictionary
  static Future<List<String>> loadDictionary() async {
    final text = await rootBundle.loadString(
      'assets/dictionary/greek-dictionary-2.txt',
    );

    final bannedWords = {'ΗΛΙΘΙΟΣ', 'ΧΟΝΤΡΗ', 'ΒΛΑΚΑΣ'};
    final lines = text.split('\n');

    final words = <String>[];

    for (var word in lines) {
      word = word.trim().toUpperCase();
      if (word.length < 3 || bannedWords.contains(word)) continue;
      words.add(word);
    }

    return words;
  }

  // Load base words
  static Future<List<String>> loadBaseWords() async {
    final text = await rootBundle.loadString(
      'assets/dictionary/greek_base_words.txt',
    );

    final bannedWords = {'ΗΛΙΘΙΟΣ', 'ΧΟΝΤΡΗ', 'ΒΛΑΚΑΣ'};
    final lines = text.split('\n');

    final baseWords = <String>[];

    for (var word in lines) {
      word = word.trim().toUpperCase();
      if (word.length < 3 || bannedWords.contains(word)) continue;
      baseWords.add(word);
    }

    return baseWords;
  }

  // Get level configuration (base word and subwords)
  static Future<Map<String, dynamic>> getLevelConfiguration(int level) async {
    final dictionary = await loadDictionary();
    final baseWords = await loadBaseWords();

    // Sorted list of requirement keys from highest to lowest
    final sortedKeys = levelRequirements.keys.toList()..sort();

    // Find the requirement keys that could apply (e.g., level <= key)
    int index = sortedKeys.lastIndexWhere((k) => k <= level);

    while (index >= 0) {
      final requirementKey = sortedKeys[index];
      final requirements = levelRequirements[requirementKey]!;

      final totalTiles = requirements['totalTiles'];
      final subwordRequirements =
          requirements['subwords'] as List<Map<String, dynamic>>;

      // Calculate minimum base word length needed
      int minBaseLength = 0;
      for (final req in subwordRequirements) {
        final length = req['length'] as int;
        minBaseLength = max(minBaseLength, length); // Longest subword length
      }

      final validBaseWords =
          baseWords.where((word) {
            final tileCount = word.length;
            return tileCount >= minBaseLength;
          }).toList();

      validBaseWords.shuffle(Random());

      for (final base in validBaseWords) {
        final subwords = findValidSubwords(base, dictionary);
        final selectedSubwords = <String>[];

        bool meetsRequirements = true;
        int currentTileCount = 0;

        // Group subwords by length for selection
        final subwordsByLength = <int, List<String>>{};
        for (var word in subwords) {
          subwordsByLength.putIfAbsent(word.length, () => []).add(word);
        }

        for (final req in subwordRequirements) {
          final length = req['length'] as int;
          final count =
              req['count'] is List
                  ? (req['count'][1] as int)
                  : req['count'] as int;

          final matchingSubwords = subwordsByLength[length] ?? [];
          if (matchingSubwords.length < count) {
            meetsRequirements = false;
            break;
          }

          matchingSubwords.shuffle(Random());
          final selected = matchingSubwords.take(count).toList();
          selectedSubwords.addAll(selected);
          currentTileCount += (length * count).toInt();
        }

        // Validate tile count
        bool tilesValid =
            totalTiles is int
                ? currentTileCount == totalTiles
                : currentTileCount >= totalTiles[0] &&
                    currentTileCount <= totalTiles[1];

        if (meetsRequirements && tilesValid) {
          return {
            'baseWord': base,
            'subwords': selectedSubwords,
            'tiles': base.split(''),
          };
        }
      }

      // No match found for this config; fallback to previous
      index -= 1;
    }

    throw Exception(
      'No base word found for level $level or any fallback requirement levels.',
    );
  }

  // Find valid subwords from a base word
  static List<String> findValidSubwords(String base, List<String> dictionary) {
    final baseLetters = _letterCount(base);

    return dictionary.where((word) {
      if (word.length > base.length) return false;

      final wordLetters = _letterCount(word);
      return wordLetters.entries.every(
        (entry) =>
            baseLetters[entry.key] != null &&
            baseLetters[entry.key]! >= entry.value,
      );
    }).toList();
  }

  // Count letters in a word
  static Map<String, int> _letterCount(String word) {
    final map = <String, int>{};
    for (final letter in word.split('')) {
      map[letter] = (map[letter] ?? 0) + 1;
    }
    return map;
  }

  // Score a word
  static int scoreWord(String word) {
    final uniqueLetters = word.split('').toSet().length;
    return word.length * 10 + uniqueLetters;
  }
}
