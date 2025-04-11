import 'dart:ui';

class GameState {
  final List<int> selectedIndices;
  final Offset? currentTouch;
  final List<String> letters;
  final List<String> validWords;
  final Set<String> foundWords;
  final List<int> letterIds;

  GameState({
    this.selectedIndices = const [],
    this.currentTouch,
    this.letters = const [],
    this.validWords = const [],
    this.foundWords = const {},
    this.letterIds = const [],
  });

  GameState copyWith({
    List<int>? selectedIndices,
    Offset? currentTouch,
    List<String>? letters,
    List<String>? validWords,
    Set<String>? foundWords,
    List<int>? letterIds,
  }) {
    return GameState(
      selectedIndices: selectedIndices ?? this.selectedIndices,
      currentTouch: currentTouch,
      letters: letters ?? this.letters,
      validWords: validWords ?? this.validWords,
      foundWords: foundWords ?? this.foundWords,
      letterIds: letterIds ?? this.letterIds,
    );
  }
}
