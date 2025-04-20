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

    // Check if a set of 3 collectibles has been completed
    if (progress.totalCollected % 3 == 0) {
      progress.setsCompleted += 1;

      // Increase the collectible count requirement
      if (progress.setsCompleted == 1) {
        progress.totalCollected = 6; // After 3, it becomes 6
      } else if (progress.setsCompleted == 2) {
        progress.totalCollected = 9; // After 6, it becomes 9
      } else {
        progress.totalCollected = 12; // After 9, set to 12 or finish
      }

      // Add the next vase index to the vaseIndices list sequentially
      if (progress.vaseIndices.length < 12) {
        final updatedVases = List<int>.from(progress.vaseIndices)
          ..add(progress.vaseIndices.length);
        progress.vaseIndices = updatedVases;
      }
    }

    // Reset collectible state
    progress.currentLevelWithIcon = null;
    progress.wordWithCollectible = null;

    // Persist changes in Isar
    await isar.writeTxn(() => isar.treasureProgress.put(progress));
    emit(TreasureLoaded(progress));
  }
}
