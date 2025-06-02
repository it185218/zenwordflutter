import 'package:flutter/services.dart' show rootBundle;

class GameHelpers {
  static Future<List<String>> loadDictionary() async {
    final text = await rootBundle.loadString(
      'assets/dictionary/greek-dictionary-2.txt',
    );

    final bannedWords = {'ΗΛΙΘΙΟΣ', 'ΧΟΝΤΡΗ', 'ΒΛΑΚΑΣ'};

    final lines = text.split('\n');

    final rootToBestWord = <String, String>{};

    for (var word in lines) {
      word = word.trim().toUpperCase();
      if (word.length < 3 || bannedWords.contains(word)) continue;

      final root = _greekRootForm(word);
      if (root.isEmpty) continue;

      // Skip derived forms, keep only root/base verb form
      if (root != word && _isGreekRootVerb(root)) {
        continue;
      }

      // Your existing logic:
      if (!rootToBestWord.containsKey(root)) {
        rootToBestWord[root] = word;
      } else if (_isGreekRootVerb(word) &&
          !_isGreekRootVerb(rootToBestWord[root]!)) {
        rootToBestWord[root] = word;
      } else if (_isGreekRootVerb(word) &&
          _isGreekRootVerb(rootToBestWord[root]!) &&
          word.length < rootToBestWord[root]!.length) {
        rootToBestWord[root] = word;
      }
    }

    return rootToBestWord.values.toList();
  }

  static Future<List<String>> loadBaseWords() async {
    final text = await rootBundle.loadString(
      'assets/dictionary/greek_base_words.txt',
    );

    final bannedWords = {'ΗΛΙΘΙΟΣ', 'ΧΟΝΤΡΗ', 'ΒΛΑΚΑΣ'};

    final lines = text.split('\n');

    final rootToBestWord = <String, String>{};

    for (var word in lines) {
      word = word.trim().toUpperCase();
      if (word.length < 3 || bannedWords.contains(word)) continue;

      final root = _greekRootForm(word);
      if (root.isEmpty) continue;

      // Skip derived forms, keep only root/base verb form
      if (root != word && _isGreekRootVerb(root)) {
        continue;
      }

      // Your existing logic:
      if (!rootToBestWord.containsKey(root)) {
        rootToBestWord[root] = word;
      } else if (_isGreekRootVerb(word) &&
          !_isGreekRootVerb(rootToBestWord[root]!)) {
        rootToBestWord[root] = word;
      } else if (_isGreekRootVerb(word) &&
          _isGreekRootVerb(rootToBestWord[root]!) &&
          word.length < rootToBestWord[root]!.length) {
        rootToBestWord[root] = word;
      }
    }

    return rootToBestWord.values.toList();
  }

  static String _greekRootForm(String word) {
    word = word.toUpperCase();

    // If word ends with 'Σ' and is longer than 4, likely a plural noun or verb 3rd person singular,
    // exclude it (your existing rule)
    if (word.endsWith('Σ') && word.length > 4) {
      return '';
    }

    // Greek verb suffixes for present tense indicative, imperative, subjunctive, etc.
    // Cover common endings in active voice:
    const verbSuffixes = [
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
    ];

    // Other common suffixes (noun/adjective endings)
    const otherSuffixes = ['Α', 'Ε', 'Ο', 'ΟΝ', 'ΕΣ'];

    // Combine suffixes, with verb suffixes checked first
    final allSuffixes = [...verbSuffixes, ...otherSuffixes];

    for (final suffix in allSuffixes) {
      if (word.endsWith(suffix) && word.length > suffix.length + 2) {
        final root = word.substring(0, word.length - suffix.length);

        // If root too short, ignore stripping to avoid nonsense roots
        if (root.length < 3) {
          return word; // return original if root is too short
        }

        // If suffix is a verb suffix, add back Ω to get infinitive root
        if (verbSuffixes.contains(suffix)) {
          // Handle cases where root already ends with Ω (rare but possible)
          if (root.endsWith('Ω')) {
            return root;
          }
          return '$rootΩ';
        }

        // Otherwise just return root (for nouns/adjectives)
        return root;
      }
    }

    // If no suffix matched, return word unchanged
    return word;
  }

  static bool _isGreekRootVerb(String word) {
    return word.endsWith('Ω') && word.length > 2;
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
