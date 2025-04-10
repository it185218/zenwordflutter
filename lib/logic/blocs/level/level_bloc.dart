import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:zenwordflutter/data/model/level.dart';
import 'level_event.dart';
import 'level_state.dart';

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  final Isar isar;

  LevelBloc(this.isar) : super(LevelState.initial()) {
    on<LoadLevels>(_onLoadLevels);
    on<CompleteLevel>(_onCompleteLevel);
  }

  Future<void> _onLoadLevels(LoadLevels event, Emitter<LevelState> emit) async {
    final levels = await isar.levels.where().sortByNumber().findAll();

    if (levels.isEmpty) {
      final level1 = Level(number: 1);
      await isar.writeTxn(() => isar.levels.put(level1));
      emit(LevelState(currentLevel: 1, completedCount: 0));
    } else {
      final current = levels.firstWhere(
        (lvl) => !lvl.isCompleted,
        orElse: () => levels.last,
      );
      final completed = levels.where((lvl) => lvl.isCompleted).length;
      emit(LevelState(currentLevel: current.number, completedCount: completed));
    }
  }

  Future<void> _onCompleteLevel(
    CompleteLevel event,
    Emitter<LevelState> emit,
  ) async {
    final level =
        await isar.levels.filter().numberEqualTo(event.level).findFirst();

    if (level != null && !level.isCompleted) {
      await isar.writeTxn(() {
        level.isCompleted = true;
        return isar.levels.put(level);
      });

      final next =
          await isar.levels.filter().numberEqualTo(event.level + 1).findFirst();

      if (next == null) {
        await isar.writeTxn(() {
          return isar.levels.put(Level(number: event.level + 1));
        });
      }

      final completed =
          await isar.levels.filter().isCompletedEqualTo(true).count();

      emit(
        LevelState(currentLevel: event.level + 1, completedCount: completed),
      );
    }
  }
}
