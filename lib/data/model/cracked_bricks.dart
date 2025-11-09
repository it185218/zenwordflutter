import 'package:isar/isar.dart';

part 'cracked_bricks.g.dart';

@collection
class CrackedBricks {
  Id id = Isar.autoIncrement;

  /// Unique identifier for the set (0 to 11)
  int setIndex;

  /// Tracks if a brick is cracked (12 bricks)
  List<bool> crackedStates = List.filled(12, false);

  /// Tracks where the 4 pieces are
  List<int> pieceIndices = [];

  CrackedBricks({required this.setIndex});
}
