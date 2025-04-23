import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class GameHelpers {
  static Future<List<String>> loadDictionary() async {
    final text = await rootBundle.loadString(
      'assets/dictionary/short-dictionary.txt',
    );
    return text
        .split('\n')
        .map((word) => word.trim())
        .where((word) => word.length >= 3)
        .toList();
  }

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

  static Map<String, int> _letterCount(String word) {
    final map = <String, int>{};
    for (final letter in word.split('')) {
      map[letter] = (map[letter] ?? 0) + 1;
    }
    return map;
  }

  static String pickAdaptiveBaseWord(
    List<String> dictionary,
    double skillScore,
  ) {
    int length;
    if (skillScore < 0.4) {
      length = 3;
    } else if (skillScore < 0.6) {
      length = 4;
    } else if (skillScore < 0.75) {
      length = 5;
    } else if (skillScore < 0.85) {
      length = 6;
    } else {
      length = 7;
    }

    List<String> filtered =
        dictionary.where((w) => w.length == length).toList();

    // If no words match the intended length, fallback gracefully
    if (filtered.isEmpty) {
      // Try shorter lengths as fallback
      for (
        int fallbackLength = length - 1;
        fallbackLength >= 3;
        fallbackLength--
      ) {
        filtered = dictionary.where((w) => w.length == fallbackLength).toList();
        if (filtered.isNotEmpty) break;
      }

      // If still empty, fallback to whole dictionary
      if (filtered.isEmpty) filtered = dictionary;
    }

    return filtered[Random().nextInt(filtered.length)];
  }

  static int scoreWord(String word) {
    final uniqueLetters = word.split('').toSet().length;
    return word.length * 10 + uniqueLetters;
  }
}
