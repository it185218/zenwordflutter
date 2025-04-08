import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class GameHelpers {
  static Future<List<String>> loadDictionary() async {
    final text = await rootBundle.loadString(
      'assets/dictionary/greek-dictionary.txt',
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

  static String pickRandomBaseWord(List<String> dictionary, int length) {
    final filtered = dictionary.where((w) => w.length == length).toList();
    return filtered[Random().nextInt(filtered.length)];
  }
}
