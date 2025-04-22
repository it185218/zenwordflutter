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

    if (progress.totalCollected % 3 == 0) {
      progress.setsCompleted += 1;
      if (progress.setsCompleted == 1) {
        progress.totalCollected = 6;
      } else if (progress.setsCompleted == 2) {
        progress.totalCollected = 9;
      } else {
        progress.totalCollected = 12;
      }

      if (progress.vaseIndices.length < 12) {
        final updatedVases = List<int>.from(progress.vaseIndices)
          ..add(progress.vaseIndices.length);
        progress.vaseIndices = updatedVases;
      }
    }

    // Clear collectible data completely
    progress.currentLevelWithIcon = null;
    progress.wordWithCollectible = null;
    progress.collectibleTileIndex = null;

    await isar.writeTxn(() => isar.treasureProgress.put(progress));
    emit(TreasureLoaded(progress));
  }
}
