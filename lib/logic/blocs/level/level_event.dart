abstract class LevelEvent {}

class LoadLevels extends LevelEvent {}

class CompleteLevel extends LevelEvent {
  final int level;
  CompleteLevel(this.level);
}
