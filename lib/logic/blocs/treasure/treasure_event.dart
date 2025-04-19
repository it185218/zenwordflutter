abstract class TreasureEvent {}

class LoadTreasure extends TreasureEvent {}

class GenerateCollectible extends TreasureEvent {
  final int level;
  final List<String> validWords;
  final Set<String> foundWords;

  GenerateCollectible({
    required this.level,
    required this.validWords,
    required this.foundWords,
  });
}

class CollectTreasure extends TreasureEvent {
  final String word;

  CollectTreasure({required this.word});
}
