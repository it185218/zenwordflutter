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

  // CHANGED: Fixed subword validation, prevented duplicates, ensured two 5-letter subwords
  static Future<Map<String, dynamic>> getLevelConfiguration(
    int level, {
    int retryCount = 0,
    bool allowMultipleSolutions = false,
  }) async {
    final dictionary = await loadDictionary();
    final baseWords = await loadBaseWords();

    // Sorted list of requirement keys from highest to lowest
    final sortedKeys = levelRequirements.keys.toList()..sort();

    // Find the requirement keys that could apply (e.g., level <= key)
    int index = sortedKeys.lastIndexWhere((k) => k <= level);

    while (index >= 0) {
      final requirementKey = sortedKeys[index];
      var requirements = levelRequirements[requirementKey]!;
      var subwordRequirements = List<Map<String, dynamic>>.from(
        requirements['subwords'] as List<Map<String, dynamic>>,
      );
      var totalTiles = requirements['totalTiles'];

      // Calculate maximum subword length for prioritization
      int maxSubwordLength = 0;
      for (final req in subwordRequirements) {
        final length = req['length'] as int;
        maxSubwordLength = max(maxSubwordLength, length);
      }

      // Prioritize shortest base word lengths starting from maxSubwordLength
      final availableBaseLengths =
          baseWords.map((word) => word.length).toSet().toList()..sort();
      final baseLengthsToTry =
          availableBaseLengths
              .where((length) => length >= maxSubwordLength)
              .toList();

      // Track if any base word was valid to avoid premature fallback
      bool anyBaseWordTried = false;

      for (int preferredBaseLength in baseLengthsToTry) {
        final validBaseWords =
            baseWords
                .where((word) => word.length == preferredBaseLength)
                .toList();

        if (validBaseWords.isEmpty) {
          print(
            "🚫 No base words of length $preferredBaseLength for level $level",
          );
          continue;
        }

        anyBaseWordTried = true;

        validBaseWords.shuffle(Random());

        for (final base in validBaseWords) {
          // Filter subwords based on allowMultipleSolutions
          final subwords =
              findValidSubwords(base, dictionary)
                  .where(
                    (word) =>
                        allowMultipleSolutions ||
                        word.length != base.length ||
                        word == base,
                  )
                  .toList();

          // CHANGED: Check subword availability against original requirements
          final subwordsByLength = <int, List<String>>{};
          for (var word in subwords) {
            subwordsByLength.putIfAbsent(word.length, () => []).add(word);
          }

          bool hasEnoughSubwords = true;
          for (final req in subwordRequirements) {
            final length = req['length'] as int;
            final count =
                req['count'] is List
                    ? req['count'][1] as int
                    : req['count'] as int;
            final matchingSubwords = subwordsByLength[length] ?? [];
            // Adjust count if base word is used as a subword
            final adjustedCount =
                (length == maxSubwordLength &&
                        preferredBaseLength == maxSubwordLength)
                    ? (count > 1 ? count - 1 : count)
                    : count;
            if (matchingSubwords.length < adjustedCount) {
              hasEnoughSubwords = false;
              print(
                "🚫 Skipping base '$base': insufficient $length-letter subwords upfront; need $adjustedCount, have ${matchingSubwords.length}",
              );
              break;
            }
          }

          if (!hasEnoughSubwords) continue;

          // Try base word as one of the required subwords
          final selectedSubwords = <String>{}; // Use Set to avoid duplicates
          bool meetsRequirements = true;
          int currentTileCount = 0;

          // Include base word once if it matches maxSubwordLength
          if (preferredBaseLength == maxSubwordLength) {
            selectedSubwords.add(base);
            currentTileCount += base.length;
          }

          // Select unique subwords
          for (final req in subwordRequirements) {
            final length = req['length'] as int;
            final count =
                req['count'] is List
                    ? req['count'][1] as int
                    : req['count'] as int;
            final adjustedCount =
                (length == maxSubwordLength &&
                        preferredBaseLength == maxSubwordLength)
                    ? (count > 1 ? count - 1 : count)
                    : count;

            final matchingSubwords =
                (subwordsByLength[length] ?? [])
                    .where((word) => !selectedSubwords.contains(word))
                    .toList();
            if (matchingSubwords.length < adjustedCount) {
              meetsRequirements = false;
              print(
                "🚫 Skipping base '$base': insufficient unique $length-letter subwords; need $adjustedCount, have ${matchingSubwords.length}",
              );
              break;
            }

            matchingSubwords.shuffle(Random());
            final selected = matchingSubwords.take(adjustedCount).toList();
            selectedSubwords.addAll(selected);
            currentTileCount += (length * adjustedCount).toInt();
          }

          // Validate exact counts with unique subwords
          if (meetsRequirements) {
            final subwordCounts = <int, int>{};
            for (var word in selectedSubwords) {
              subwordCounts[word.length] =
                  (subwordCounts[word.length] ?? 0) + 1;
            }

            bool countsValid = true;
            for (final req in subwordRequirements) {
              final length = req['length'] as int;
              final requiredCount =
                  req['count'] is List
                      ? req['count'][1] as int
                      : req['count'] as int;
              final actualCount = subwordCounts[length] ?? 0;
              if (actualCount != requiredCount) {
                meetsRequirements = false;
                print(
                  "🚫 Skipping base '$base': incorrect $length-letter subword count; need exactly $requiredCount, have $actualCount",
                );
                break;
              }
            }

            bool tilesValid =
                totalTiles is int
                    ? currentTileCount == totalTiles
                    : currentTileCount >= totalTiles[0] &&
                        currentTileCount <= totalTiles[1];

            if (meetsRequirements && tilesValid && countsValid) {
              print(
                "✅ Found valid configuration for level $level with base '$base', subwords: ${selectedSubwords.toList()}",
              );
              return {
                'baseWord': base,
                'subwords': selectedSubwords.toList(),
                'tiles': base.split(''),
              };
            } else if (!tilesValid) {
              print(
                "🚫 Skipping base '$base': invalid tile count; got $currentTileCount, need $totalTiles",
              );
            }
          }

          // Try original requirements with base word not as subword
          selectedSubwords.clear();
          currentTileCount = 0;

          meetsRequirements = true;
          for (final req in subwordRequirements) {
            final length = req['length'] as int;
            final count =
                req['count'] is List
                    ? req['count'][1] as int
                    : req['count'] as int;
            final matchingSubwords =
                (subwordsByLength[length] ?? [])
                    .where((word) => !selectedSubwords.contains(word))
                    .toList();
            if (matchingSubwords.length < count) {
              meetsRequirements = false;
              print(
                "🚫 Skipping base '$base': insufficient $length-letter subwords (second attempt); need $count, have ${matchingSubwords.length}",
              );
              break;
            }

            matchingSubwords.shuffle(Random());
            final selected = matchingSubwords.take(count).toList();
            selectedSubwords.addAll(selected);
            currentTileCount += (length * count).toInt();
          }

          if (meetsRequirements) {
            final subwordCounts = <int, int>{};
            for (var word in selectedSubwords) {
              subwordCounts[word.length] =
                  (subwordCounts[word.length] ?? 0) + 1;
            }

            bool countsValid = true;
            for (final req in subwordRequirements) {
              final length = req['length'] as int;
              final requiredCount =
                  req['count'] is List
                      ? req['count'][1] as int
                      : req['count'] as int;
              final actualCount = subwordCounts[length] ?? 0;
              if (actualCount != requiredCount) {
                meetsRequirements = false;
                print(
                  "🚫 Skipping base '$base': incorrect $length-letter subword count (second attempt); need exactly $requiredCount, have $actualCount",
                );
                break;
              }
            }

            bool tilesValid =
                totalTiles is int
                    ? currentTileCount == totalTiles
                    : currentTileCount >= totalTiles[0] &&
                        currentTileCount <= totalTiles[1];

            if (meetsRequirements && tilesValid && countsValid) {
              print(
                "✅ Found valid configuration for level $level with base '$base', subwords: ${selectedSubwords.toList()}",
              );
              return {
                'baseWord': base,
                'subwords': selectedSubwords.toList(),
                'tiles': base.split(''),
              };
            } else if (!tilesValid) {
              print(
                "🚫 Skipping base '$base': invalid tile count (second attempt); got $currentTileCount, need $totalTiles",
              );
            }
          }
        }
      }

      // Only fallback to reduced subword counts if no base words were valid
      if (anyBaseWordTried && retryCount < 3) {
        var reducedRequirements =
            subwordRequirements.map((req) {
              final count = req['count'];
              int newCount = count is List ? (count[1] as int) : count as int;
              if (newCount > 1) newCount--;
              return {
                'length': req['length'],
                'count': count is List ? [newCount, newCount] : newCount,
              };
            }).toList();

        // Recalculate totalTiles for reduced requirements
        int minTiles = 0, maxTiles = 0;
        for (var req in reducedRequirements) {
          final length = req['length'] as int;
          final count =
              req['count'] is List
                  ? (req['count'][0] as int)
                  : req['count'] as int;
          minTiles += length * count;
          maxTiles += length * count;
        }
        var newTotalTiles =
            minTiles == maxTiles ? minTiles : [minTiles, maxTiles];

        print(
          "🔄 Fallback: Trying reduced requirements for level $level: $reducedRequirements",
        );

        final retryResult = await getLevelConfiguration(
          level,
          retryCount: retryCount + 1,
          allowMultipleSolutions: allowMultipleSolutions,
        );
        if (retryResult != null) {
          return retryResult;
        }
      }

      // Fallback to previous requirement level only after exhausting all base words and reduced requirements
      print(
        "⚠️ No valid configuration for level $level with requirement key $requirementKey; trying previous level requirements",
      );
      index -= 1;
    }

    print(
      "❌ Failed to find configuration for level $level after all fallbacks",
    );
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
