import 'dart:ui';

abstract class GameEvent {}

class GameLetterSelected extends GameEvent {
  final int index;
  GameLetterSelected(this.index);
}

class GameTouchUpdate extends GameEvent {
  final Offset offset;
  GameTouchUpdate(this.offset);
}

class GameTouchEnd extends GameEvent {}

class GameUndoLastSelection extends GameEvent {}

class GameStarted extends GameEvent {
  final int level;
  final bool allowMultipleSolutions;

  GameStarted({required this.level, this.allowMultipleSolutions = false});
}

class GameShuffleLetters extends GameEvent {}

class GameUseHintLetter extends GameEvent {}

class GameUseHintFirstLetters extends GameEvent {}

class ResetGameState extends GameEvent {}

class GameSettingChanged extends GameEvent {
  final bool allowMultipleSolutions;

  GameSettingChanged(this.allowMultipleSolutions);
}
