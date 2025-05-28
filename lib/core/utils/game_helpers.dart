import 'package:flutter/services.dart' show rootBundle;

class GameHelpers {
  static Future<List<String>> loadDictionary() async {
    final text = await rootBundle.loadString(
      'assets/dictionary/greek-dictionary-2.txt',
    );

    final bannedWords = {'ΗΛΙΘΙΟΣ', 'ΧΟΝΤΡΗ', 'ΒΛΑΚΑΣ'};

    final lines = text.split('\n');

    final seenRoots = <String>{};
    final filteredWords = <String>[];

    for (var word in lines) {
      word = word.trim().toUpperCase();

      if (word.length < 3 || bannedWords.contains(word)) continue;

      final root = _greekRootForm(word);

      if (!seenRoots.contains(root)) {
        seenRoots.add(root);
        filteredWords.add(word);
      }
    }

    return filteredWords;
  }

  static Future<List<String>> loadBaseWords() async {
    final text = await rootBundle.loadString(
      'assets/dictionary/greek_base_words.txt',
    );
    final lines = text.split('\n');
    final seenRoots = <String>{};
    final filteredWords = <String>[];

    for (var word in lines) {
      word = word.trim().toUpperCase();
      if (word.length < 3) continue;

      final root = _greekRootForm(word);
      if (!seenRoots.contains(root)) {
        seenRoots.add(root);
        filteredWords.add(word);
      }
    }

    return filteredWords;
  }

  static String _greekRootForm(String word) {
    // Remove trailing Σ if it's likely a plural or conjugated form
    if (word.endsWith('Σ') && word.length > 4) {
      word = word.substring(0, word.length - 1);
    }

    // Remove common Greek suffixes (very basic stemmer)
    const suffixes = [
      'ΟΥΜΕ',
      'ΕΤΕ',
      'ΑΜΕ',
      'ΑΤΕ',
      'ΕΙΣ',
      'ΕΙ',
      'Ω',
      'Α',
      'Ε',
      'Ο',
    ];

    for (final suffix in suffixes) {
      if (word.endsWith(suffix) && word.length > suffix.length + 2) {
        return word.substring(0, word.length - suffix.length);
      }
    }

    return word;
  }

  // Search subwords from the base word
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
