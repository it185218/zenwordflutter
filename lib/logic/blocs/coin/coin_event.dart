// coin_event.dart
abstract class CoinEvent {}

class LoadCoins extends CoinEvent {}

class AddCoins extends CoinEvent {
  final int amount;
  AddCoins(this.amount);
}

class SpendCoins extends CoinEvent {
  final int amount;
  SpendCoins(this.amount);
}
