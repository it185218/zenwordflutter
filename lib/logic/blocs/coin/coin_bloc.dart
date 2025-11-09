import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:zenwordflutter/data/model/player_data.dart';

import 'coin_event.dart';
import 'coin_state.dart';

// Bloc responsible for managing coin-related operations such as loading,
// adding, and spending coins. Coins are persisted using Isar.
class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final Isar isar;

  // Initializes the [CoinBloc] with the given Isar instance.
  CoinBloc(this.isar) : super(CoinState.initial()) {
    on<LoadCoins>(_onLoadCoins);
    on<AddCoins>(_onAddCoins);
    on<SpendCoins>(_onSpendCoins);
  }

  // Loads the player's coin balance from the database.
  // If no player data exists, initializes a new [PlayerData] with default values.
  Future<void> _onLoadCoins(LoadCoins event, Emitter<CoinState> emit) async {
    final player = await isar.playerDatas.get(1);
    if (player == null) {
      final newPlayer = PlayerData()..id = 1;
      await isar.writeTxn(() => isar.playerDatas.put(newPlayer));
      emit(CoinState(coins: newPlayer.coins));
    } else {
      emit(CoinState(coins: player.coins));
    }
  }

  // Rewarding coins (extra words, 10 levels completed)
  Future<void> _onAddCoins(AddCoins event, Emitter<CoinState> emit) async {
    final player = await isar.playerDatas.get(1);
    if (player != null) {
      player.coins += event.amount;
      await isar.writeTxn(() => isar.playerDatas.put(player));
      emit(CoinState(coins: player.coins));
    }
  }

  // For hints
  Future<void> _onSpendCoins(SpendCoins event, Emitter<CoinState> emit) async {
    final player = await isar.playerDatas.get(1);
    if (player != null && player.coins >= event.amount) {
      player.coins -= event.amount;
      await isar.writeTxn(() => isar.playerDatas.put(player));
      emit(CoinState(coins: player.coins));
    }
  }
}
