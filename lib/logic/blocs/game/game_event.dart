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

class GameStarted extends GameEvent {}
