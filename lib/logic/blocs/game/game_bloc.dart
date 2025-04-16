import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:zenwordflutter/data/model/performance.dart';
import '../../../core/utils/game_serialization.dart';
import '../../../core/utils/performance_helper.dart';
import '../../../data/model/saved_game.dart';
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
    final isar = Isar.getInstance();
    final saved =
        await isar!.savedGames.filter().levelEqualTo(event.level).findFirst();

    // Count total found extras across all levels
    final allSaves = await isar.savedGames.where().findAll();
    final totalExtras =
        allSaves.expand((game) => game.foundExtras).toSet().length;
    final maxMilestone = allSaves
        .map((g) => g.extraWordMilestone)
        .fold(0, (a, b) => a > b ? a : b);

    if (saved != null) {
      // Load saved game
      emit(
        state.copyWith(
          level: event.level,
          letters: saved.letters,
          validWords: saved.validWords,
          foundWords: saved.foundWords.toSet(),
          foundExtras: saved.foundExtras.toSet(),
          additionalWords: saved.additionalWords.toSet(),
          letterIds: saved.letterIds,
          revealedLetters: deserializeRevealed(saved.revealedLetters),
          selectedIndices: [],
          currentTouch: null,
          totalFoundExtras: totalExtras,
          extraWordMilestone: maxMilestone,
        ),
      );
      return;
    }

    // Generate new level
    _dictionary = await GameHelpers.loadDictionary();

    final history =
        await isar.performances.where().sortByLevelDesc().limit(10).findAll();
    final skillScore = computeSkillScore(history, sampleSize: 5);
    int gridWordCount = (6 + (skillScore * 10)).round().clamp(6, 12);

    final baseWord = GameHelpers.pickAdaptiveBaseWord(_dictionary, skillScore);
    final ids = List.generate(baseWord.length, (i) => i);
    final validSubwords = GameHelpers.findValidSubwords(baseWord, _dictionary);

    validSubwords.sort(
      (a, b) => GameHelpers.scoreWord(b).compareTo(GameHelpers.scoreWord(a)),
    );
    final topWords =
        validSubwords
            .where((w) => w != baseWord)
            .take(gridWordCount - 1)
            .toList();
    topWords.add(baseWord);

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

    final newState = state.copyWith(
      level: event.level,
      letters: baseWord.split(''),
      letterIds: ids,
      validWords: gridWords,
      additionalWords: extras,
      foundWords: {},
      foundExtras: {},
      revealedLetters: {},
      selectedIndices: [],
      currentTouch: null,
      totalFoundExtras: totalExtras,
    );

    emit(newState);

    // Save to Isar
    final game =
        SavedGame()
          ..level = event.level
          ..baseWord = baseWord
          ..letters = newState.letters
          ..letterIds = ids
          ..validWords = gridWords
          ..foundWords = []
          ..additionalWords = extras.toList()
          ..revealedLetters = '';

    await isar.writeTxn(() => isar.savedGames.put(game));
  }

  Future<void> _saveGameState(GameState state) async {
    final isar = Isar.getInstance();
    final existing =
        await isar!.savedGames.filter().levelEqualTo(state.level).findFirst();

    if (existing != null) {
      existing.foundWords = state.foundWords.toList();
      existing.foundExtras =
          state.foundWords
              .where((w) => state.additionalWords.contains(w))
              .toList(); // ✅ Save only extras that were found
      existing.additionalWords = state.additionalWords.toList();
      existing.revealedLetters = serializeRevealed(state.revealedLetters);
      existing.extraWordMilestone = state.extraWordMilestone;

      await isar.writeTxn(() => isar.savedGames.put(existing));
    }
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

  Future<void> _onTouchEnd(GameTouchEnd event, Emitter<GameState> emit) async {
    final word = state.selectedIndices.map((i) => state.letters[i]).join();

    final isValid = state.validWords.contains(word);
    final isAdditional = state.additionalWords.contains(word);
    final alreadyFound = state.foundWords.contains(word);

    if ((isValid || isAdditional) && !alreadyFound) {
      final updatedFound = {...state.foundWords, word};
      final updatedExtras =
          isAdditional
              ? {...state.additionalWords, word}
              : state.additionalWords;
      final updatedFoundExtras =
          isAdditional ? {...state.foundExtras, word} : state.foundExtras;

      // Load all saved games and compute new global total of found extra words
      final allSaves = await Isar.getInstance()!.savedGames.where().findAll();
      final globalFoundExtras = allSaves.expand((g) => g.foundExtras).toSet();
      if (isAdditional) globalFoundExtras.add(word); // include this new one
      final updatedTotalExtras = globalFoundExtras.length;

      final newState = state.copyWith(
        selectedIndices: [],
        currentTouch: null,
        foundWords: updatedFound,
        additionalWords: updatedExtras,
        foundExtras: updatedFoundExtras,
        totalFoundExtras: updatedTotalExtras,
      );

      emit(newState);
      await _saveGameState(newState);

      // **Fix**: Only reward if the total found extras surpass the next milestone (10, 20, etc.)
      final rewardThreshold = 10;
      final currentMilestone = state.extraWordMilestone;

      // Calculate the new milestone (10, 20, 30...)
      final nextMilestone =
          (updatedTotalExtras ~/ rewardThreshold) * rewardThreshold;

      if (nextMilestone > currentMilestone) {
        final rewardedState = newState.copyWith(
          extraWordMilestone: nextMilestone,
        );
        emit(rewardedState);
        await _saveGameState(rewardedState);
        await _revealRandomWord(rewardedState, emit);
      }
    } else {
      emit(state.copyWith(selectedIndices: [], currentTouch: null));
    }
  }

  Future<void> _revealRandomWord(
    GameState state,
    Emitter<GameState> emit,
  ) async {
    final validWords =
        state.validWords
            .where((word) => !state.revealedLetters.containsKey(word))
            .toList();
    if (validWords.isEmpty) return;

    final randomWord = validWords[Random().nextInt(validWords.length)];

    final revealedLetters = Map<String, Set<int>>.from(state.revealedLetters);
    revealedLetters[randomWord] = {0}; // Reveal first letter

    final newState = state.copyWith(
      revealedLetters: revealedLetters,
      // ✅ DO NOT reset totalFoundExtras
    );

    emit(newState);
    await _saveGameState(newState);
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

  Future<void> _onUseHintLetter(
    GameUseHintLetter event,
    Emitter<GameState> emit,
  ) async {
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

    final newState = state.copyWith(revealedLetters: updatedRevealed);
    emit(newState);
    await _saveGameState(newState);
  }
}
