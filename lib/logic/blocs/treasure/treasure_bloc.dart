import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:zenwordflutter/data/model/cracked_bricks.dart';

import '../../../data/model/treasure_progress.dart';
import 'treasure_event.dart';
import 'treasure_state.dart';

class TreasureBloc extends Bloc<TreasureEvent, TreasureState> {
  final Isar isar;

  TreasureBloc(this.isar) : super(TreasureInitial()) {
    on<LoadTreasure>(_onLoad);
    on<GenerateCollectible>(_onGenerate);
    on<CollectHammer>(_onCollect);
    on<LoadCrackedBricks>(_onLoadCrackedBricks);
    on<CrackBrick>(_onCrackBrick);
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

    if (event.level % 2 == 0 && event.level >= 3) {
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
    CollectHammer event,
    Emitter<TreasureState> emit,
  ) async {
    if (state is! TreasureLoaded) return;

    final progress = (state as TreasureLoaded).progress;

    progress.totalHammers += 3;

    progress.currentLevelWithIcon = null;
    progress.wordWithCollectible = null;
    progress.collectibleTileIndex = null;

    await isar.writeTxn(() => isar.treasureProgress.put(progress));
    emit(TreasureLoaded(progress));
  }

  Future<void> _onLoadCrackedBricks(
    LoadCrackedBricks event,
    Emitter<TreasureState> emit,
  ) async {
    emit(CrackedBricksLoading());

    for (int i = 0; i < 12; i++) {
      final crackedEntry =
          await isar.crackedBricks.filter().setIndexEqualTo(i).findFirst();

      if (crackedEntry != null) {
        final revealedAll = crackedEntry.pieceIndices.every(
          (j) => crackedEntry.crackedStates[j],
        );
        if (!revealedAll) {
          emit(
            CrackedBricksLoaded(
              setIndex: i,
              vaseIndex: i,
              cracked: List.from(crackedEntry.crackedStates),
              pieceIndices: List.from(crackedEntry.pieceIndices),
              allPiecesFound: false,
            ),
          );
          return;
        }
      } else {
        final indices = List.generate(12, (i) => i)..shuffle();
        final pieceIndices = indices.take(4).toList();
        final cracked = List.filled(12, false);

        final entry =
            CrackedBricks(setIndex: i)
              ..crackedStates = cracked
              ..pieceIndices = pieceIndices;

        await isar.writeTxn(() async {
          await isar.crackedBricks.put(entry);
        });

        emit(
          CrackedBricksLoaded(
            setIndex: i,
            vaseIndex: i,
            cracked: cracked,
            pieceIndices: pieceIndices,
            allPiecesFound: false,
          ),
        );
        return;
      }
    }

    // If all sets cracked
    emit(
      CrackedBricksLoaded(
        setIndex: 0,
        vaseIndex: 0,
        cracked: List.filled(12, true),
        pieceIndices: [],
        allPiecesFound: true,
      ),
    );
  }

  Future<void> _onCrackBrick(
    CrackBrick event,
    Emitter<TreasureState> emit,
  ) async {
    if (state is! CrackedBricksLoaded) return;

    final currentState = state as CrackedBricksLoaded;

    if (currentState.cracked[event.brickIndex]) return; // Already cracked

    final treasureProgress = await isar.treasureProgress.where().findFirst();
    if (treasureProgress == null) return;

    // 🛑 Check if there are hammers available
    if (treasureProgress.totalHammers <= 0) {
      // Not enough hammers, do not allow cracking
      return;
    }

    // ✅ Deduct one hammer
    treasureProgress.totalHammers--;

    // Proceed with cracking
    final cracked = List<bool>.from(currentState.cracked);
    cracked[event.brickIndex] = true;

    final crackedEntry =
        await isar.crackedBricks
            .filter()
            .setIndexEqualTo(currentState.setIndex)
            .findFirst();

    if (crackedEntry != null) {
      crackedEntry.crackedStates[event.brickIndex] = true;
      await isar.writeTxn(() async {
        await isar.crackedBricks.put(crackedEntry);
      });
    }

    final allPiecesFound = currentState.pieceIndices.every((i) => cracked[i]);

    final pieces = List<int>.from(treasureProgress.currentPieces);
    while (pieces.length < 12) {
      pieces.add(0);
    }

    // ✅ Count piece only if this was a collectible tile
    if (currentState.pieceIndices.contains(event.brickIndex)) {
      if (pieces[currentState.setIndex] < currentState.pieceIndices.length) {
        pieces[currentState.setIndex] += 1;
      }
    }

    treasureProgress.currentPieces = pieces;

    if (allPiecesFound) {
      final completedVases = List<int>.from(treasureProgress.vaseIndices);
      if (!completedVases.contains(currentState.setIndex)) {
        completedVases.add(currentState.setIndex);
      }
      treasureProgress.vaseIndices = completedVases;
    }

    await isar.writeTxn(() => isar.treasureProgress.put(treasureProgress));

    emit(
      CrackedBricksLoaded(
        setIndex: currentState.setIndex,
        vaseIndex: currentState.vaseIndex,
        cracked: cracked,
        pieceIndices: currentState.pieceIndices,
        allPiecesFound: allPiecesFound,
      ),
    );
  }
}
