import 'dart:ui';

class GameState {
  final List<int> selectedIndices;
  final Offset? currentTouch;
  final List<String> letters;
  final List<String> validWords;
  final Set<String> foundWords;

  GameState({
    this.selectedIndices = const [],
    this.currentTouch,
    this.letters = const [],
    this.validWords = const [],
    this.foundWords = const {},
  });

  GameState copyWith({
    List<int>? selectedIndices,
    Offset? currentTouch,
    List<String>? letters,
    List<String>? validWords,
    Set<String>? foundWords,
  }) {
    return GameState(
      selectedIndices: selectedIndices ?? this.selectedIndices,
      currentTouch: currentTouch,
      letters: letters ?? this.letters,
      validWords: validWords ?? this.validWords,
      foundWords: foundWords ?? this.foundWords,
    );
  }
}
