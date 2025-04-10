class LevelState {
  final int currentLevel;
  final int completedCount;

  LevelState({required this.currentLevel, required this.completedCount});

  factory LevelState.initial() =>
      LevelState(currentLevel: 1, completedCount: 0);
}
