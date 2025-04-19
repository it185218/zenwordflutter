import '../../../data/model/treasure_progress.dart';

abstract class TreasureState {}

class TreasureInitial extends TreasureState {}

class TreasureLoaded extends TreasureState {
  final TreasureProgress progress;

  TreasureLoaded(this.progress);
}
