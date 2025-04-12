import 'package:isar/isar.dart';

part 'performance.g.dart';

@collection
class Performance {
  Id id = Isar.autoIncrement;

  late int level;
  late int totalWords;
  late int foundWords;
  late int avgFoundLength;
  late int durationSeconds;

  double get completionRate => foundWords / totalWords;
}
