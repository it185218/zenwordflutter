import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:zenwordflutter/data/model/performance.dart';
import '../../../core/utils/performance_helper.dart';
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
    on<GameUseHintLetter>(_onUseHintLetter);
  }

  Future<void> _onGameStarted(
    GameStarted event,
    Emitter<GameState> emit,
  ) async {
    _dictionary = await GameHelpers.loadDictionary();

    final isar = Isar.getInstance();
    final history =
        await isar!.performances.where().sortByLevelDesc().limit(10).findAll();

    final skillScore = computeSkillScore(history, sampleSize: 5);

    // 👇 Dynamic grid size based on skill
    int gridWordCount = (6 + (skillScore * 10)).round(); // range: 6–16
    gridWordCount = gridWordCount.clamp(6, 12); // Enforce max of 12

    final baseWord = GameHelpers.pickAdaptiveBaseWord(_dictionary, skillScore);
    final ids = List.generate(baseWord.length, (i) => i);
    final validSubwords = GameHelpers.findValidSubwords(baseWord, _dictionary);

    // Step 1: Sort all subwords by score (descending)
    validSubwords.sort((a, b) {
      int scoreA = GameHelpers.scoreWord(a);
      int scoreB = GameHelpers.scoreWord(b);
      return scoreB.compareTo(scoreA);
    });

    // Step 2: Take top N - 1, excluding base word for now
    final topWords =
        validSubwords
            .where((word) => word != baseWord)
            .take(gridWordCount - 1)
            .toList();

    // Step 3: Add the base word (ensure it's included)
    topWords.add(baseWord);

    // Step 4: Sort by length, then alphabetically
    topWords.sort((a, b) {
      final lenCompare = a.length.compareTo(b.length);
      return lenCompare != 0 ? lenCompare : a.compareTo(b);
    });

    final gridWords = topWords;
    final extras = validSubwords.toSet().difference(gridWords.toSet());

    // 🔥 Print here
    print("🔤 Base word: $baseWord");
    print("🧩 Grid Words (${gridWords.length}): ${gridWords.join(', ')}");
    print("🔥 Extras (${extras.length}): ${extras.join(', ')}");

    print("Skill score: $skillScore");

    emit(
      state.copyWith(
        letters: baseWord.split(''),
        validWords: gridWords,
        selectedIndices: [],
        letterIds: ids,
        additionalWords: extras,
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
    final isAdditional = state.additionalWords.contains(word);
    final alreadyFound = state.foundWords.contains(word);

    if ((isValid || isAdditional) && !alreadyFound) {
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

  void _onUseHintLetter(GameUseHintLetter event, Emitter<GameState> emit) {
    // Pick a random unfound word
    final remainingWords =
        state.validWords
            .where((word) => !state.foundWords.contains(word))
            .toList();

    if (remainingWords.isEmpty) return;

    final randomWord = (remainingWords..shuffle()).first;

    // Pick a random unrevealed letter index
    final revealed = state.revealedLetters[randomWord] ?? <int>{};
    final unrevealedIndices =
        List.generate(
          randomWord.length,
          (i) => i,
        ).where((i) => !revealed.contains(i)).toList();

    if (unrevealedIndices.isEmpty) return;

    final letterIndex = (unrevealedIndices..shuffle()).first;

    final updatedRevealed = {
      ...state.revealedLetters,
      randomWord: {...revealed, letterIndex},
    };

    emit(state.copyWith(revealedLetters: updatedRevealed));
  }
}
