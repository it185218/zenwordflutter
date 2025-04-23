import 'package:isar/isar.dart';

part 'saved_game.g.dart';

@collection
class SavedGame {
  Id id = Isar.autoIncrement;

  late int level;
  late String baseWord;
  late List<String> letters;
  late List<int> letterIds;
  late List<String> validWords;
  late List<String> foundWords;
  List<String> foundExtras = [];
  late List<String> additionalWords;
  int extraWordMilestone = 0;
  bool allowMultipleSolutions = false;

  /// Serialized Map<String, Set<int>>
  /// Stored as "word:index1,index2;another:index1"
  late String revealedLetters;
  late String hintRevealedLetters;
}
