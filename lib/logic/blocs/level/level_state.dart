class LevelState {
  final int currentLevel;

  LevelState({required this.currentLevel});

  factory LevelState.initial() => LevelState(currentLevel: 1);
}
