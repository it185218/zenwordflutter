import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class GameHelpers {
  static Future<List<String>> loadDictionary() async {
    final text = await rootBundle.loadString(
      'assets/dictionary/greek-dictionary-2.txt',
    );

    final bannedWords = {'ΗΛΙΘΙΟΣ', 'ΧΟΝΤΡΗ', 'ΒΛΑΚΑΣ'};

    // Common suffixes in Greek to exclude (plural, participle, etc.)
    final excludedSuffixes = [
      'ΟΙ',
      'ΕΙΣ',
      'ΩΝ',
      'ΗΣ',
      'ΕΣ',
      'ΜΕΝΟΣ',
      'ΜΕΝΗ',
      'ΜΕΝΟ',
      'ΟΥΣΑ',
      'ΟΝΤΑΣ',
      'ΟΥΝ',
      'ΟΥΣΕΣ',
      'ΟΥΜΕ',
      'ΕΤΕ',
      'ΕΙ',
      'ΑΝ',
      'ΑΜΕ',
      'ΑΣ',
      'ΑΤΕ',
    ];

    final allWords =
        text
            .split('\n')
            .map((word) => word.trim().toUpperCase())
            .where((word) => word.length >= 3 && !bannedWords.contains(word))
            .toSet(); // Use set to remove duplicates

    final filtered = <String>{};

    for (final word in allWords) {
      // Skip words ending with excluded suffixes
      if (excludedSuffixes.any((suffix) => word.endsWith(suffix))) continue;

      // Skip if a shorter version of this word already exists
      bool isInflection = filtered.any(
        (base) => word.startsWith(base) && word != base,
      );
      if (isInflection) continue;

      filtered.add(word);
    }

    return filtered.toList();
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

  // Pick baseword length base from skill score
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

    List<String> candidates =
        dictionary.where((w) => w.length == length).toList();

    if (candidates.isEmpty) {
      for (int fallback = length - 1; fallback >= 3; fallback--) {
        candidates = dictionary.where((w) => w.length == fallback).toList();
        if (candidates.isNotEmpty) break;
      }
      if (candidates.isEmpty) candidates = dictionary;
    }

    // Sort by number of difficult letters (descending) as skill increases
    if (skillScore >= 0.75) {
      candidates.sort((a, b) {
        int aScore = _countDifficultLetters(a);
        int bScore = _countDifficultLetters(b);
        return bScore.compareTo(aScore);
      });

      // Top N% with most difficult letters
      int topN = (candidates.length * 0.3).round();
      candidates = candidates.take(topN).toList();
    }

    return candidates[Random().nextInt(candidates.length)];
  }

  static int _countDifficultLetters(String word) {
    return word.split('').where(difficultLetters.contains).length;
  }

  static const difficultLetters = {'Ξ', 'Ψ', 'Ζ', 'Χ', 'Φ', 'Θ'};

  static int scoreWord(String word) {
    final uniqueLetters = word.split('').toSet().length;
    return word.length * 10 + uniqueLetters;
  }
}
