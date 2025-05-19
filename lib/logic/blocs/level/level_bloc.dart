import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:zenwordflutter/data/model/level.dart';
import 'package:zenwordflutter/data/model/performance.dart';
import 'level_event.dart';
import 'level_state.dart';

// Manages level progression, loading, and completion using Isar for persistence.
class LevelBloc extends Bloc<LevelEvent, LevelState> {
  final Isar isar;

  // Initializes the [LevelBloc] with the given Isar instance.
  LevelBloc(this.isar) : super(LevelState.initial()) {
    on<LoadLevels>(_onLoadLevels);
    on<CompleteLevel>(_onCompleteLevel);
  }

  // If no levels exist, initializes level 1. Otherwise, emits the current level
  Future<void> _onLoadLevels(LoadLevels event, Emitter<LevelState> emit) async {
    final levels = await isar.levels.where().sortByNumber().findAll();

    if (levels.isEmpty) {
      // Initialize the first level if none exist
      final level1 = Level(number: 1);
      await isar.writeTxn(() => isar.levels.put(level1));
      emit(LevelState(currentLevel: 1, completedCount: 0));
    } else {
      // Find the first uncompleted level or fallback to the last one
      final current = levels.firstWhere(
        (lvl) => !lvl.isCompleted,
        orElse: () => levels.last,
      );

      // Count how many levels have been completed
      final completed = levels.where((lvl) => lvl.isCompleted).length;
      emit(LevelState(currentLevel: current.number, completedCount: completed));
    }
  }

  // Marks the specified level as completed and saves performance metrics
  // including number of words found, average word length, and time taken.
  // Automatically creates the next level if it doesn’t exist.
  // Emits updated state with incremented current level and completed count.
  Future<void> _onCompleteLevel(
    CompleteLevel event,
    Emitter<LevelState> emit,
  ) async {
    final level =
        await isar.levels.filter().numberEqualTo(event.level).findFirst();

    if (level != null && !level.isCompleted) {
      await isar.writeTxn(() async {
        // Mark current level as completed
        level.isCompleted = true;
        await isar.levels.put(level);

        // Save the player's performance data for this level
        final performance =
            Performance()
              ..level = event.level
              ..totalWords = event.validWords.length
              ..foundWords = event.foundWords.length
              ..avgFoundLength =
                  event.foundWords.isEmpty
                      ? 0
                      : (event.foundWords
                              .map((w) => w.length)
                              .reduce((a, b) => a + b) ~/
                          event.foundWords.length)
              ..durationSeconds = event.durationSeconds;

        await isar.performances.put(performance);
      });

      // Create the next level if it doesn’t already exist
      final next =
          await isar.levels.filter().numberEqualTo(event.level + 1).findFirst();

      if (next == null) {
        await isar.writeTxn(() {
          return isar.levels.put(Level(number: event.level + 1));
        });
      }

      // Emit the new state with updated current level and completed count
      final completed =
          await isar.levels.filter().isCompletedEqualTo(true).count();

      emit(
        LevelState(currentLevel: event.level + 1, completedCount: completed),
      );
    }
  }
}
