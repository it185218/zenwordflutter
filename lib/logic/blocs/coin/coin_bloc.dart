// coin_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:zenwordflutter/data/model/player_data.dart';

import 'coin_event.dart';
import 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final Isar isar;

  CoinBloc(this.isar) : super(CoinState.initial()) {
    on<LoadCoins>(_onLoadCoins);
    on<AddCoins>(_onAddCoins);
    on<SpendCoins>(_onSpendCoins);
  }

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

  Future<void> _onAddCoins(AddCoins event, Emitter<CoinState> emit) async {
    final player = await isar.playerDatas.get(1);
    if (player != null) {
      player.coins += event.amount;
      await isar.writeTxn(() => isar.playerDatas.put(player));
      emit(CoinState(coins: player.coins));
    }
  }

  Future<void> _onSpendCoins(SpendCoins event, Emitter<CoinState> emit) async {
    final player = await isar.playerDatas.get(1);
    if (player != null && player.coins >= event.amount) {
      player.coins -= event.amount;
      await isar.writeTxn(() => isar.playerDatas.put(player));
      emit(CoinState(coins: player.coins));
    }
  }
}
