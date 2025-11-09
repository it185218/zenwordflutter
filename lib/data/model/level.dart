import 'package:isar/isar.dart';

part 'level.g.dart';

@collection
class Level {
  Id id = Isar.autoIncrement;

  late int number;
  late bool isCompleted;

  Level({required this.number, this.isCompleted = false});
}
