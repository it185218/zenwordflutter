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
    on<GameUseHintFirstLetters>(_onUseHintFirstLetters);
    on<ResetGameState>((event, emit) {
      emit(
        state.copyWith(
          letters: [],
          foundWords: {},
          letterIds: [],
          revealedLetters: {},
          hintRevealedLetters: {},
          selectedIndices: [],
          currentTouch: null,
        ),
      );
    });
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
          hintRevealedLetters: deserializeRevealed(saved.hintRevealedLetters),
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

    final baseWord = GameHelpers.pickAdaptiveBaseWord(_dictionary, skillScore);

    final baseLetters = baseWord.split('');
    final baseIds = List.generate(baseLetters.length, (i) => i);

    // Pair each letter with its id, shuffle together
    final zipped = List.generate(
      baseLetters.length,
      (i) => MapEntry(baseLetters[i], baseIds[i]),
    );
    zipped.shuffle();

    final shuffledLetters = zipped.map((e) => e.key).toList();
    final shuffledIds = zipped.map((e) => e.value).toList();

    final validSubwords = GameHelpers.findValidSubwords(baseWord, _dictionary);

    validSubwords.sort(
      (a, b) => GameHelpers.scoreWord(b).compareTo(GameHelpers.scoreWord(a)),
    );

    final filteredWords = validSubwords.where((w) => w != baseWord).toList();
    final balancedWords = selectBalancedGridWords(
      baseWord: baseWord,
      sortedWords: filteredWords,
    );

    final extras = validSubwords.toSet().difference(balancedWords.toSet());

    // 🔥 Print here
    print("🔤 Base word: $baseWord");
    print(
      "🧩 Grid Words (${balancedWords.length}): ${balancedWords.join(', ')}",
    );
    print("🔥 Extras (${extras.length}): ${extras.join(', ')}");

    print("Skill score: $skillScore");

    final newState = state.copyWith(
      level: event.level,
      letters: shuffledLetters,
      letterIds: shuffledIds,
      validWords: balancedWords,
      additionalWords: extras,
      foundWords: {},
      foundExtras: {},
      revealedLetters: {},
      hintRevealedLetters: {},
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
          ..letters = shuffledLetters
          ..letterIds = shuffledIds
          ..validWords = balancedWords
          ..foundWords = []
          ..additionalWords = extras.toList()
          ..revealedLetters = ''
          ..hintRevealedLetters = '';

    await isar.writeTxn(() => isar.savedGames.put(game));
  }

  List<String> selectBalancedGridWords({
    required String baseWord,
    required List<String> sortedWords,
    int maxWords = 12,
    int maxPerColumn = 12,
    int maxRowLength = 10,
  }) {
    final result = <String>[baseWord];
    final usedWords = <String>{baseWord};

    // Check if the base word is longer than 6 characters
    final isBaseWordLarge = baseWord.length > 6;

    // If base word is larger than 6, limit the number of words to 14 (including the base word)
    if (isBaseWordLarge) {
      maxWords = 12;
    }

    for (var word in sortedWords) {
      if (result.length >= maxWords) break;
      if (usedWords.contains(word)) continue;

      // Try placing the word in combination with existing ones
      bool added = false;

      for (int i = 0; i <= result.length; i++) {
        final col1 = result.sublist(0, (result.length / 2).ceil());
        final col2 = result.sublist((result.length / 2).ceil());

        final minLen = col1.length <= col2.length ? col1.length : col2.length;

        // Construct current row pairs to test placement
        for (int row = 0; row < minLen; row++) {
          final left = col1.length > row ? col1[row] : '';
          final right = col2.length > row ? col2[row] : '';

          // Try adding to column 1
          if (left.isEmpty && word.length + right.length <= maxRowLength) {
            result.insert(row, word);
            usedWords.add(word);
            added = true;
            break;
          }

          // Try adding to column 2
          if (right.isEmpty && word.length + left.length <= maxRowLength) {
            result.insert((result.length / 2).ceil() + row, word);
            usedWords.add(word);
            added = true;
            break;
          }
        }

        if (added) break;
      }

      // Fallback: add if space left and word can fit alone
      if (!added && result.length < maxWords) {
        result.add(word);
        usedWords.add(word);
      }
    }

    final groupedByLength = <int, List<String>>{};

    for (var word in result) {
      groupedByLength.putIfAbsent(word.length, () => []).add(word);
    }

    final sortedByLengthThenScore =
        groupedByLength.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

    final finalList =
        sortedByLengthThenScore
            .expand((entry) {
              entry.value.sort(
                (a, b) => GameHelpers.scoreWord(
                  b,
                ).compareTo(GameHelpers.scoreWord(a)),
              );
              return entry.value;
            })
            .take(maxWords)
            .toList();

    return finalList;
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
      existing.hintRevealedLetters = serializeRevealed(
        state.hintRevealedLetters,
      );
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

    final newExtraWordFound = isAdditional && !alreadyFound;

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

      if (newExtraWordFound) {
        await _checkAndRewardMilestone(newState, emit);
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
    revealedLetters[randomWord] = {0};

    final newState = state.copyWith(revealedLetters: revealedLetters);

    emit(newState);
    await _saveGameState(newState);
  }

  Future<void> _checkAndRewardMilestone(
    GameState state,
    Emitter<GameState> emit,
  ) async {
    final rewardThreshold = 10;
    final currentMilestone = state.extraWordMilestone;

    final nextMilestone =
        (state.totalFoundExtras ~/ rewardThreshold) * rewardThreshold;

    if (nextMilestone > currentMilestone) {
      final updatedState = state.copyWith(extraWordMilestone: nextMilestone);
      emit(updatedState);
      await _saveGameState(updatedState);
      await _revealRandomWord(updatedState, emit);
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

    // Pick a random unrevealed letter index from the hint-specific map
    final revealed = state.revealedLetters[randomWord] ?? <int>{};
    final hintRevealed = state.hintRevealedLetters[randomWord] ?? <int>{};

    final unrevealedIndices =
        List.generate(randomWord.length, (i) => i)
            .where((i) => !revealed.contains(i) && !hintRevealed.contains(i))
            .toList();

    if (unrevealedIndices.isEmpty) return;

    // Only reveal 1 letter for hint
    final letterIndex = unrevealedIndices.first;

    final updatedHintRevealed = {
      ...state.hintRevealedLetters,
      randomWord: {...hintRevealed, letterIndex},
    };

    final newState = state.copyWith(hintRevealedLetters: updatedHintRevealed);
    emit(newState);
    await _saveGameState(newState);
  }

  Future<void> _onUseHintFirstLetters(
    GameUseHintFirstLetters event,
    Emitter<GameState> emit,
  ) async {
    // Get unfound words
    final remainingWords =
        state.validWords
            .where((word) => !state.foundWords.contains(word))
            .toList();

    if (remainingWords.isEmpty) return;

    // Shuffle and limit to 5 words max
    remainingWords.shuffle();
    final wordsToHint = remainingWords.take(5);

    final updatedHintRevealed = Map<String, Set<int>>.from(
      state.hintRevealedLetters,
    );

    for (final word in wordsToHint) {
      final alreadyRevealed = updatedHintRevealed[word] ?? <int>{};
      final mainRevealed = state.revealedLetters[word] ?? <int>{};

      // Only add the first letter if not already revealed
      if (!alreadyRevealed.contains(0) && !mainRevealed.contains(0)) {
        updatedHintRevealed[word] = {...alreadyRevealed, 0};
      }
    }

    final newState = state.copyWith(hintRevealedLetters: updatedHintRevealed);
    emit(newState);
    await _saveGameState(newState);
  }
}
