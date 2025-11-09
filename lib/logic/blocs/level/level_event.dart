abstract class LevelEvent {}

class LoadLevels extends LevelEvent {}

class CompleteLevel extends LevelEvent {
  final int level;
  final int durationSeconds;
  final Set<String> foundWords;
  final List<String> validWords;

  CompleteLevel({
    required this.level,
    required this.durationSeconds,
    required this.foundWords,
    required this.validWords,
  });
}
