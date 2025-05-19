import 'dart:ui';

class GameState {
  final int level;
  final List<int> selectedIndices;
  final Offset? currentTouch;
  final List<String> letters;
  final List<String> validWords;
  final Set<String> foundWords;
  final Set<String> foundExtras;
  final Set<String> additionalWords;
  final List<int> letterIds;
  final Map<String, Set<int>> revealedLetters;
  final Map<String, Set<int>> hintRevealedLetters;
  final int totalFoundExtras;
  final int extraWordMilestone;
  final bool allowMultipleSolutions;

  GameState({
    this.level = 0,
    this.selectedIndices = const [],
    this.currentTouch,
    this.letters = const [],
    this.validWords = const [],
    this.foundWords = const {},
    this.foundExtras = const {},
    this.additionalWords = const {},
    this.letterIds = const [],
    this.revealedLetters = const {},
    this.hintRevealedLetters = const {},
    this.totalFoundExtras = 0,
    this.extraWordMilestone = 0,
    this.allowMultipleSolutions = false,
  });

  GameState copyWith({
    int? level,
    List<int>? selectedIndices,
    Offset? currentTouch,
    List<String>? letters,
    List<String>? validWords,
    Set<String>? foundWords,
    Set<String>? foundExtras,
    Set<String>? additionalWords,
    List<int>? letterIds,
    Map<String, Set<int>>? revealedLetters,
    Map<String, Set<int>>? hintRevealedLetters,
    int? totalFoundExtras,
    int? extraWordMilestone,
    bool? allowMultipleSolutions,
  }) {
    return GameState(
      level: level ?? this.level,
      selectedIndices: selectedIndices ?? this.selectedIndices,
      currentTouch: currentTouch,
      letters: letters ?? this.letters,
      validWords: validWords ?? this.validWords,
      foundWords: foundWords ?? this.foundWords,
      foundExtras: foundExtras ?? this.foundExtras,
      additionalWords: additionalWords ?? this.additionalWords,
      letterIds: letterIds ?? this.letterIds,
      revealedLetters:
          revealedLetters ?? this.revealedLetters, // Used by extra words reward
      hintRevealedLetters:
          hintRevealedLetters ??
          this.hintRevealedLetters, // Used by light bulb and rocket launch hints
      totalFoundExtras: totalFoundExtras ?? this.totalFoundExtras,
      extraWordMilestone: extraWordMilestone ?? this.extraWordMilestone,
      allowMultipleSolutions:
          allowMultipleSolutions ?? this.allowMultipleSolutions,
    );
  }
}
