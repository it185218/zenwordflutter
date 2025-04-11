import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_event.dart';
import 'game_state.dart';

import '../../../core/utils/game_helpers.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  List<String> _dictionary = [];

  GameBloc() : super(GameState()) {
    on<GameStarted>(_onGameStarted);
    on<GameLetterSelected>(_onLetterSelected);
    on<GameTouchUpdate>(_onTouchUpdate);
    on<GameTouchEnd>(_onTouchEnd);
    on<GameUndoLastSelection>(_onUndoLastSelection);
    on<GameShuffleLetters>(_onShuffleLetters);
  }

  Future<void> _onGameStarted(
    GameStarted event,
    Emitter<GameState> emit,
  ) async {
    _dictionary = await GameHelpers.loadDictionary();
    final baseWord = GameHelpers.pickRandomBaseWord(_dictionary, 5);

    final ids = List.generate(baseWord.length, (i) => i);

    final validSubwords = GameHelpers.findValidSubwords(baseWord, _dictionary)
      ..sort((a, b) {
        final lengthCompare = a.length.compareTo(b.length);
        return lengthCompare != 0 ? lengthCompare : a.compareTo(b);
      });

    // 🔥 Print here
    print("🔤 Base word: $baseWord");
    print("🧩 Subwords (${validSubwords.length}): ${validSubwords.join(', ')}");

    emit(
      state.copyWith(
        letters: baseWord.split(''),
        validWords: validSubwords,
        selectedIndices: [],
        letterIds: ids,
      ),
    );
  }

  void _onLetterSelected(GameLetterSelected event, Emitter<GameState> emit) {
    if (!state.selectedIndices.contains(event.index)) {
      emit(
        state.copyWith(
          selectedIndices: [...state.selectedIndices, event.index],
        ),
      );
    }
  }

  void _onUndoLastSelection(
    GameUndoLastSelection event,
    Emitter<GameState> emit,
  ) {
    if (state.selectedIndices.length > 1) {
      final updated = List<int>.from(state.selectedIndices)
        ..removeLast(); // Remove the last selected letter
      emit(state.copyWith(selectedIndices: updated));
    }
  }

  void _onTouchUpdate(GameTouchUpdate event, Emitter<GameState> emit) {
    emit(state.copyWith(currentTouch: event.offset));
  }

  void _onTouchEnd(GameTouchEnd event, Emitter<GameState> emit) {
    final word = state.selectedIndices.map((i) => state.letters[i]).join();

    final isValid = state.validWords.contains(word);
    final alreadyFound = state.foundWords.contains(word);

    if (isValid && !alreadyFound) {
      final updatedFound = {...state.foundWords, word};
      emit(
        state.copyWith(
          selectedIndices: [],
          currentTouch: null,
          foundWords: updatedFound,
        ),
      );
    } else {
      emit(state.copyWith(selectedIndices: [], currentTouch: null));
    }
  }

  void _onShuffleLetters(GameShuffleLetters event, Emitter<GameState> emit) {
    final shuffled = List<String>.from(state.letters);
    final shuffledIds = List<int>.from(state.letterIds);

    final zipped = List.generate(
      shuffled.length,
      (i) => MapEntry(shuffled[i], shuffledIds[i]),
    );
    zipped.shuffle();

    emit(
      state.copyWith(
        letters: zipped.map((e) => e.key).toList(),
        letterIds: zipped.map((e) => e.value).toList(),
      ),
    );
  }
}
