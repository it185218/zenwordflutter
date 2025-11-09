import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:zenwordflutter/data/model/performance.dart';
import '../../../core/utils/game_serialization.dart';
import '../../../core/utils/performance_helper.dart';
import '../../../data/model/global_stats.dart';
import '../../../data/model/saved_game.dart';
import 'game_event.dart';
import 'game_state.dart';

import '../../../core/utils/game_helpers.dart';

// A Bloc that manages the state and logic for game.
// It handles events such as starting a game, selecting letters, using hints,
// and shuffling letters. Game progress is persisted with Isar.
class GameBloc extends Bloc<GameEvent, GameState> {
  // The list of dictionary words used to validate subwords.
  List<String> _dictionary = [];

  // Constructs a [GameBloc] and registers all event handlers.
  GameBloc() : super(GameState()) {
    on<GameStarted>(_onGameStarted);
    on<GameLetterSelected>(_onLetterSelected);
    on<GameTouchUpdate>(_onTouchUpdate);
    on<GameTouchEnd>(_onTouchEnd);
    on<GameUndoLastSelection>(_onUndoLastSelection);
    on<GameShuffleLetters>(_onShuffleLetters);
    on<GameUseHintLetter>(_onUseHintLetter);
    on<GameUseHintFirstLetters>(_onUseHintFirstLetters);
    on<GameSettingChanged>(_onGameSettingChanged);
    on<ResetGameState>((event, emit) {
      // Reset current level game state to default
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

  // Loads a saved game if available, or generates a new one from the dictionary.
  Future<void> _onGameStarted(
    GameStarted event,
    Emitter<GameState> emit,
  ) async {
    final isar = Isar.getInstance();
    final saved =
        await isar!.savedGames.filter().levelEqualTo(event.level).findFirst();

    // Whether to allow multiple solution words of same length as base word
    final allowMultipleSolutions = event.allowMultipleSolutions;

    // Compute total number of extra words found across all levels
    GlobalStats? stats = await isar.globalStats.get(0);
    if (stats == null) {
      stats = GlobalStats();
      await isar.writeTxn(() => isar.globalStats.put(stats!));
    }

    final totalExtras = stats.totalFoundExtras;
    final maxMilestone = stats.extraWordMilestone;

    if (saved != null) {
      // Resume from saved game state
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
          allowMultipleSolutions: saved.allowMultipleSolutions,
        ),
      );
      return;
    }

    final history =
        await isar.performances.where().sortByLevelDesc().limit(10).findAll();
    final skillScore = computeSkillScore(history, sampleSize: 5);

    // CHANGED: Pass allowMultipleSolutions to getLevelConfiguration
    final config = await GameHelpers.getLevelConfiguration(
      event.level,
      allowMultipleSolutions: allowMultipleSolutions,
    );
    final baseWord = config['baseWord'] as String;
    final baseLetters = config['tiles'] as List<String>;

    _dictionary = await GameHelpers.loadDictionary();
    final filteredDictionary = _dictionary.where((w) => w != baseWord).toList();

    // Pair each letter with its id, shuffle together
    final baseIds = List.generate(baseLetters.length, (i) => i);
    final zipped = List.generate(
      baseLetters.length,
      (i) => MapEntry(baseLetters[i], baseIds[i]),
    );
    zipped.shuffle();

    final shuffledLetters = zipped.map((e) => e.key).toList();
    final shuffledIds = zipped.map((e) => e.value).toList();

    // Get level requirements
    final sortedKeys = GameHelpers.levelRequirements.keys.toList()..sort();
    final requirementKey = sortedKeys.lastWhere((k) => k <= event.level);
    final requirements = GameHelpers.levelRequirements[requirementKey]!;
    final subwordRequirements =
        requirements['subwords'] as List<Map<String, dynamic>>;

    // Select exactly the required subwords
    final balancedWords = <String>[baseWord]; // Include base word
    final allValidSubwords = GameHelpers.findValidSubwords(
      baseWord,
      filteredDictionary,
    );
    final wordsByLength = <int, List<String>>{};
    for (var word in allValidSubwords) {
      if (allowMultipleSolutions || word.length != baseWord.length) {
        wordsByLength.putIfAbsent(word.length, () => []).add(word);
      }
    }

    bool meetsRequirements = true;
    for (final req in subwordRequirements) {
      final length = req['length'] as int;
      final count =
          req['count'] is List ? (req['count'][1] as int) : req['count'] as int;
      final availableWords = wordsByLength[length] ?? [];
      availableWords.shuffle(Random());
      if (availableWords.length < count) {
        meetsRequirements = false;
        break;
      }
      balancedWords.addAll(availableWords.take(count));
    }

    // If requirements not met, fallback to minimal valid words
    if (!meetsRequirements) {
      balancedWords.clear();
      balancedWords.add(baseWord);
      for (final req in subwordRequirements) {
        final length = req['length'] as int;
        final count =
            req['count'] is List
                ? (req['count'][0] as int)
                : req['count'] as int;
        final availableWords = wordsByLength[length] ?? [];
        availableWords.shuffle(Random());
        balancedWords.addAll(availableWords.take(count));
      }
    }

    balancedWords.sort((a, b) => a.length.compareTo(b.length));

    // Remaining words are considered extra
    final extras = allValidSubwords.toSet().difference(balancedWords.toSet());

    // Debug print logs
    print("🔤 Base word: $baseWord");
    print(
      "🧩 Grid Words (${balancedWords.length}): ${balancedWords.join(', ')}",
    );
    print("🔥 Extras (${extras.length}): ${extras.join(', ')}");
    print("Skill score: $skillScore");
    print("Allow Multiple Solutions: $allowMultipleSolutions");

    // Emit the initial state of the new game
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

    // Save new game state
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
          ..hintRevealedLetters = ''
          ..allowMultipleSolutions = event.allowMultipleSolutions
          ..totalFoundExtras = totalExtras;

    await isar.writeTxn(() => isar.savedGames.put(game));
  }

  // Saves the current in-progress game state to Isar database.
  Future<void> _saveGameState(GameState state) async {
    final isar = Isar.getInstance();
    final existing =
        await isar!.savedGames.filter().levelEqualTo(state.level).findFirst();

    if (existing != null) {
      existing.foundWords = state.foundWords.toList();
      existing.foundExtras =
          state.foundWords
              .where((w) => state.additionalWords.contains(w))
              .toList(); // Save only extras that were found
      existing.additionalWords = state.additionalWords.toList();
      existing.revealedLetters = serializeRevealed(state.revealedLetters);
      existing.hintRevealedLetters = serializeRevealed(
        state.hintRevealedLetters,
      );
      existing.extraWordMilestone = state.extraWordMilestone;
      existing.totalFoundExtras = state.totalFoundExtras;
      existing.allowMultipleSolutions = state.allowMultipleSolutions;

      await isar.writeTxn(() => isar.savedGames.put(existing));
    }
  }

  // Handles letter selection during gameplay.
  // Adds the selected index if it hasn’t been selected yet.
  void _onLetterSelected(GameLetterSelected event, Emitter<GameState> emit) {
    if (!state.selectedIndices.contains(event.index)) {
      emit(
        state.copyWith(
          selectedIndices: [...state.selectedIndices, event.index],
        ),
      );
    }
  }

  // Handles undoing the last letter selection in the current word path.
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

  // Updates the UI with the current touch offset during drag/selection.
  void _onTouchUpdate(GameTouchUpdate event, Emitter<GameState> emit) {
    emit(state.copyWith(currentTouch: event.offset));
  }

  // Ends a word selection attempt, checks for word validity,
  // updates found and extra words, saves state, and rewards if applicable.
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
      final updatedTotalExtras =
          state.totalFoundExtras + (newExtraWordFound ? 1 : 0);

      final isar = Isar.getInstance();
      final globalStats = await isar!.globalStats.get(0);
      if (globalStats != null) {
        globalStats.totalFoundExtras = updatedTotalExtras;
        globalStats.extraWordMilestone = state.extraWordMilestone;
        await isar.writeTxn(() => isar.globalStats.put(globalStats));
      }

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

      // Check for rewards if a new extra word was found
      if (newExtraWordFound) {
        await _checkAndRewardMilestone(newState, emit);
      }
    } else {
      emit(state.copyWith(selectedIndices: [], currentTouch: null));
    }
  }

  // Randomly reveals the first letter of one unfound word, used as a milestone reward.
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

    final newState = state.copyWith(revealedLetters: revealedLetters);

    emit(newState);
    await _saveGameState(newState);
  }

  // Checks whether the player reached a milestone (every 10 extra words),
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

      final isar = Isar.getInstance();
      final stats = await isar!.globalStats.get(0);
      if (stats != null) {
        stats.extraWordMilestone = nextMilestone;
        await isar.writeTxn(() => isar.globalStats.put(stats));
      }
    }
  }

  // Shuffles the order of displayed letter tiles (and their IDs).
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

  // Reveals one letter of a random unfound word.
  // If the word becomes fully revealed, it is marked as found.
  Future<void> _onUseHintLetter(
    GameUseHintLetter event,
    Emitter<GameState> emit,
  ) async {
    final remainingWords =
        state.validWords
            .where((word) => !state.foundWords.contains(word))
            .toList();

    if (remainingWords.isEmpty) return;

    final randomWord = (remainingWords..shuffle()).first;

    final revealed = state.revealedLetters[randomWord] ?? <int>{};
    final hintRevealed = state.hintRevealedLetters[randomWord] ?? <int>{};

    final unrevealedIndices =
        List.generate(randomWord.length, (i) => i)
            .where((i) => !revealed.contains(i) && !hintRevealed.contains(i))
            .toList();

    if (unrevealedIndices.isEmpty) return;

    final letterIndex = unrevealedIndices.first;

    final updatedHintRevealed = {
      ...state.hintRevealedLetters,
      randomWord: {...hintRevealed, letterIndex},
    };

    final isFullyRevealed =
        (updatedHintRevealed[randomWord]?.length ?? 0) + (revealed.length) ==
        randomWord.length;

    Set<String> updatedFoundWords = {...state.foundWords};
    if (isFullyRevealed) {
      updatedFoundWords.add(randomWord);
    }

    final newState = state.copyWith(
      hintRevealedLetters: updatedHintRevealed,
      foundWords: updatedFoundWords,
    );

    emit(newState);
    await _saveGameState(newState);

    if (state.additionalWords.contains(randomWord) &&
        !state.foundExtras.contains(randomWord)) {
      await _checkAndRewardMilestone(newState, emit);
    }
  }

  // Reveals the first letter of up to 5 unfound words as a batch hint.
  // Fully revealed words are automatically marked as found.
  Future<void> _onUseHintFirstLetters(
    GameUseHintFirstLetters event,
    Emitter<GameState> emit,
  ) async {
    // Get all unfound words
    final remainingWords =
        state.validWords
            .where((word) => !state.foundWords.contains(word))
            .toList();

    if (remainingWords.isEmpty) return;

    remainingWords.shuffle();

    // Clone existing hintRevealedLetters and foundWords
    final updatedHintRevealed = Map<String, Set<int>>.from(
      state.hintRevealedLetters,
    );
    final updatedFoundWords = Set<String>.from(state.foundWords);

    int lettersRevealed = 0;

    for (final word in remainingWords) {
      if (lettersRevealed >= 5) break;

      final alreadyHinted = updatedHintRevealed[word] ?? <int>{};
      final alreadyRevealed = state.revealedLetters[word] ?? <int>{};
      final totalRevealed = {...alreadyHinted, ...alreadyRevealed};

      // Find the first unrevealed letter index
      for (int i = 0; i < word.length; i++) {
        if (!totalRevealed.contains(i)) {
          final newHinted = {...alreadyHinted, i};
          updatedHintRevealed[word] = newHinted;
          lettersRevealed++;

          // Check if this word is now fully revealed
          if (newHinted.length + alreadyRevealed.length == word.length) {
            updatedFoundWords.add(word);
          }

          break; // move to next word
        }
      }
    }

    final newState = state.copyWith(
      hintRevealedLetters: updatedHintRevealed,
      foundWords: updatedFoundWords,
    );

    emit(newState);
    await _saveGameState(newState);

    for (final word in updatedFoundWords) {
      if (state.additionalWords.contains(word) &&
          !state.foundExtras.contains(word)) {
        await _checkAndRewardMilestone(newState, emit);
      }
    }
  }

  // Updates the game setting to allow or disallow multiple solutions.
  void _onGameSettingChanged(
    GameSettingChanged event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(allowMultipleSolutions: event.allowMultipleSolutions));
  }
}
