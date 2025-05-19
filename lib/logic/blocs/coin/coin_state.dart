class CoinState {
  final int coins;
  CoinState({required this.coins});

  factory CoinState.initial() => CoinState(coins: 0);
}
