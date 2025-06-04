import 'package:flutter/services.dart' show rootBundle;

class GameHelpers {
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

  static int scoreWord(String word) {
    final uniqueLetters = word.split('').toSet().length;
    return word.length * 10 + uniqueLetters;
  }
}
