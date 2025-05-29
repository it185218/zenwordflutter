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
    word = word.toUpperCase(); // Normalize

    // Exclude if ends with Σ and is longer than 4 letters
    if (word.endsWith('Σ') && word.length > 4) {
      return '';
    }

    // Expanded suffix list – longer suffixes first
    const suffixes = [
      'ΟΥΜΑΣΤΕ',
      'ΟΣΑΣΤΕ',
      'ΟΝΤΑΙ',
      'ΟΥΜΕ',
      'ΟΥΝΕ',
      'ΟΜΑΣΤΕ',
      'ΟΜΑΙ',
      'ΕΙΣΤΕ',
      'ΑΤΕ',
      'ΕΤΕ',
      'ΑΜΕ',
      'ΕΙΣ',
      'ΕΤΑΙ',
      'ΟΥΝ',
      'ΕΙ',
      'Ω',
      'Α',
      'Ε',
      'Ο',
      'ΟΝ',
      'ΕΣ',
    ];

    for (final suffix in suffixes) {
      if (word.endsWith(suffix) && word.length > suffix.length + 1) {
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
