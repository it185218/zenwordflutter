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

    // If fresh install, add level 1
    if (levels.isEmpty) {
      final level1 = Level(number: 1);
      await isar.writeTxn(() => isar.levels.put(level1));
      emit(LevelState(currentLevel: 1));
    } else {
      final current = levels.firstWhere(
        (lvl) => !lvl.isCompleted,
        orElse: () => levels.last,
      );
      emit(LevelState(currentLevel: current.number));
    }
  }

  Future<void> _onCompleteLevel(
    CompleteLevel event,
    Emitter<LevelState> emit,
  ) async {
    final level =
        await isar.levels.filter().numberEqualTo(event.level).findFirst();

    if (level != null) {
      await isar.writeTxn(() {
        level.isCompleted = true;
        return isar.levels.put(level);
      });

      // Add next level if not already there
      final next =
          await isar.levels.filter().numberEqualTo(event.level + 1).findFirst();

      if (next == null) {
        await isar.writeTxn(() {
          return isar.levels.put(Level(number: event.level + 1));
        });
      }

      emit(LevelState(currentLevel: event.level + 1));
    }
  }
}
