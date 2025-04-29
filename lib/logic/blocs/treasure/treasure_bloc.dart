import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import '../../../data/model/treasure_progress.dart';
import 'treasure_event.dart';
import 'treasure_state.dart';

class TreasureBloc extends Bloc<TreasureEvent, TreasureState> {
  final Isar isar;

  TreasureBloc(this.isar) : super(TreasureInitial()) {
    on<LoadTreasure>(_onLoad);
    on<GenerateCollectible>(_onGenerate);
    on<CollectTreasure>(_onCollect);
  }

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

  Future<void> _onGenerate(
    GenerateCollectible event,
    Emitter<TreasureState> emit,
  ) async {
    if (state is! TreasureLoaded) return;

    final progress = (state as TreasureLoaded).progress;

    if (progress.levelsGenerated.contains(event.level)) {
      return;
    }

    if (event.level % 2 == 0 && event.level >= 6) {
      final notFoundWords =
          event.validWords
              .where((word) => !event.foundWords.contains(word))
              .toList();

      if (notFoundWords.isNotEmpty) {
        final word = (notFoundWords..shuffle()).first;
        final indexRange = List.generate(word.length, (i) => i)..remove(0);
        indexRange.shuffle();
        final chosenIndex = indexRange.first;

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

  Future<void> _onCollect(
    CollectTreasure event,
    Emitter<TreasureState> emit,
  ) async {
    if (state is! TreasureLoaded) return;

    final progress = (state as TreasureLoaded).progress;

    progress.totalCollected += 1;

    // Determine how many collectibles are required for the next set
    int getRequiredForNextSet(int setsCompleted) {
      if (setsCompleted == 0) return 3;
      if (setsCompleted == 1) return 6;
      if (setsCompleted == 2) return 9;
      return 12; // After 3 sets, each subsequent set requires 12 more collectibles
    }

    final requiredForCurrentSet = getRequiredForNextSet(progress.setsCompleted);
    final currentSetStart = [0, 3, 9, 18][progress.setsCompleted];
    final collectedInCurrentSet = progress.totalCollected - currentSetStart;

    if (collectedInCurrentSet >= requiredForCurrentSet) {
      progress.setsCompleted += 1;

      if (progress.setsCompleted <= 12) {
        // Add vase images until we reach 12
        final updatedVases = List<int>.from(progress.vaseIndices)
          ..add(progress.vaseIndices.length);
        progress.vaseIndices = updatedVases;
      }
    }

    // If we reach 12 sets, we should stop increasing the sets count
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
