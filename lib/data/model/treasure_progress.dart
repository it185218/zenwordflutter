import 'package:isar/isar.dart';

part 'treasure_progress.g.dart';

@collection
class TreasureProgress {
  Id id = Isar.autoIncrement;

  int totalCollected = 0;
  int setsCompleted = 0;
  List<int> vaseIndices = [];
  int? currentLevelWithIcon;
  String? wordWithCollectible;
  int? collectibleTileIndex;
  int lastCrackedSet = 0;
  List<int> levelsGenerated = [];
}
