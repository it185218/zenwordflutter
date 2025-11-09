import '../../../data/model/treasure_progress.dart';

abstract class TreasureState {}

class TreasureInitial extends TreasureState {}

class TreasureLoaded extends TreasureState {
  final TreasureProgress progress;

  TreasureLoaded(this.progress);
}

class CrackedBricksLoading extends TreasureState {}

class CrackedBricksLoaded extends TreasureState {
  final int setIndex;
  final int vaseIndex;
  final List<bool> cracked;
  final List<int> pieceIndices;
  final bool allPiecesFound;
  final int totalHammers; // ← ADD THIS

  CrackedBricksLoaded({
    required this.setIndex,
    required this.vaseIndex,
    required this.cracked,
    required this.pieceIndices,
    required this.allPiecesFound,
    required this.totalHammers, // ← AND INITIALIZE IT
  });
}
