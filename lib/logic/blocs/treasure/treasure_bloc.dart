import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import '../../../data/model/treasure_progress.dart';
import 'treasure_event.dart';
import 'treasure_state.dart';

// Bloc to manage collectible treasures in the game.
// Handles generating collectibles in certain levels, tracking collected items,
// and rewarding players with vases upon completing sets.
class TreasureBloc extends Bloc<TreasureEvent, TreasureState> {
  final Isar isar;

  // Initializes the [TreasureBloc] with the given Isar instance.
  TreasureBloc(this.isar) : super(TreasureInitial()) {
    on<LoadTreasure>(_onLoad);
    on<GenerateCollectible>(_onGenerate);
    on<CollectTreasure>(_onCollect);
  }

  // Loads treasure progress from the database.
  // If no progress exists, creates a new [TreasureProgress] instance.
  // Emits [TreasureLoaded] state with the retrieved or newly created progress.
  Future<void> _onLoad(LoadTreasure event, Emitter<TreasureState> emit) async {
    final existing = await isar.treasureProgress.where().findFirst();
    if (existing == null) {
      final newProgress = TreasureProgress();
      await isar.writeTxn(() => isar.treasureProgress.put(newProgress));
      emit(TreasureLoaded(newProgress));
    } else {
      emit(TreasureLoaded(existing));
    }
  }

  // Handles generation of a collectible icon in eligible levels.
  // If the current level is even and ≥ 6, and it hasn’t had a collectible generated yet,
  /// chooses a random word not yet found by the player, selects a random letter index
  /// (excluding the first letter), and marks it for collectible display.
  Future<void> _onGenerate(
    GenerateCollectible event,
    Emitter<TreasureState> emit,
  ) async {
    if (state is! TreasureLoaded) return;

    final progress = (state as TreasureLoaded).progress;

    // Skip if collectible already generated for this level
    if (progress.levelsGenerated.contains(event.level)) {
      return;
    }

    // Only generate collectibles on even levels ≥ 6
    if (event.level % 2 == 0 && event.level >= 6) {
      final notFoundWords =
          event.validWords
              .where((word) => !event.foundWords.contains(word))
              .toList();

      if (notFoundWords.isNotEmpty) {
        final word = (notFoundWords..shuffle()).first;

        // Pick a random letter index (excluding first) for the collectible icon
        final indexRange = List.generate(word.length, (i) => i)..remove(0);
        indexRange.shuffle();
        final chosenIndex = indexRange.first;

        // Save collectible data in progress
        progress.currentLevelWithIcon = event.level;
        progress.wordWithCollectible = word;
        progress.collectibleTileIndex = chosenIndex;
        progress.levelsGenerated = List<int>.from(progress.levelsGenerated)
          ..add(event.level);

        await isar.writeTxn(() => isar.treasureProgress.put(progress));
        emit(TreasureLoaded(progress));
      }
    }
  }

  // Handles collecting a treasure and tracking set progress.
  // Increments the total collectible count, calculates if a set is completed,
  // and updates the list of earned vases. Maximum 12 sets (vases) are allowed.
  // Clears the current collectible word and tile index once collected.
  Future<void> _onCollect(
    CollectTreasure event,
    Emitter<TreasureState> emit,
  ) async {
    if (state is! TreasureLoaded) return;

    final progress = (state as TreasureLoaded).progress;

    progress.totalCollected += 1;

    // Determines how many collectibles are needed for the next set,
    // based on the number of sets already completed.
    int getRequiredForNextSet(int setsCompleted) {
      if (setsCompleted == 0) return 3;
      if (setsCompleted == 1) return 6;
      if (setsCompleted == 2) return 9;
      return 12; // After 3 sets, each subsequent set requires 12 more collectibles
    }

    final requiredForCurrentSet = getRequiredForNextSet(progress.setsCompleted);
    final currentSetStart = [0, 3, 9, 18][progress.setsCompleted];
    final collectedInCurrentSet = progress.totalCollected - currentSetStart;

    // Award a vase if current set is completed
    if (collectedInCurrentSet >= requiredForCurrentSet) {
      progress.setsCompleted += 1;

      if (progress.setsCompleted <= 12) {
        // Add vase images until 12 sets
        final updatedVases = List<int>.from(progress.vaseIndices)
          ..add(progress.vaseIndices.length);
        progress.vaseIndices = updatedVases;
      }
    }

    // If 12 sets is reached, stop increasing the sets count
    if (progress.setsCompleted > 12) {
      progress.setsCompleted = 12;
    }

    // Clear collectible data completely
    progress.currentLevelWithIcon = null;
    progress.wordWithCollectible = null;
    progress.collectibleTileIndex = null;

    await isar.writeTxn(() => isar.treasureProgress.put(progress));
    emit(TreasureLoaded(progress));
  }
}
