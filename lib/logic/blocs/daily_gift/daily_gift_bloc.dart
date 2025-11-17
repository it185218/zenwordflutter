import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';

import '../../../data/model/player_data.dart';
import '../coin/coin_bloc.dart';
import '../coin/coin_event.dart';
import 'daily_gift_event.dart';
import 'daily_gift_state.dart';

class DailyGiftBloc extends Bloc<DailyGiftEvent, DailyGiftState> {
  DailyGiftBloc(this._isar, this._coinBloc, {Random? random})
      : _random = random ?? Random(),
        super(DailyGiftState.initial()) {
    on<LoadDailyGift>(_onLoadDailyGift);
    on<SpinDailyGift>(_onSpinDailyGift);
  }

  final Isar _isar;
  final CoinBloc _coinBloc;
  final Random _random;

  Future<void> _onLoadDailyGift(
      LoadDailyGift event,
      Emitter<DailyGiftState> emit,
      ) async {
    final player = await _isar.playerDatas.get(1);

    if (player == null) {
      final newPlayer = PlayerData()..id = 1;
      await _isar.writeTxn(() => _isar.playerDatas.put(newPlayer));
      emit(
        state.copyWith(
          isLoading: false,
          canSpin: true,
          lastSpinDate: null,
          resetReward: true,
        ),
      );
      return;
    }

    final now = DateTime.now();
    final todayEpoch = _epochDay(now);
    final lastEpoch = player.lastDailyGiftEpochDay;
    final canSpin = lastEpoch == null || lastEpoch < todayEpoch;

    emit(
      state.copyWith(
        isLoading: false,
        canSpin: canSpin,
        lastSpinDate:
        lastEpoch != null ? _dateFromEpochDay(lastEpoch) : null,
        resetReward: true,
      ),
    );
  }

  Future<void> _onSpinDailyGift(
      SpinDailyGift event,
      Emitter<DailyGiftState> emit,
      ) async {
    if (!state.canSpin || state.isSpinning) {
      return;
    }

    final rewards = state.rewards;
    final selectedIndex = _random.nextInt(rewards.length);
    final reward = rewards[selectedIndex];

    final segmentFraction = 1 / rewards.length;
    final wobble = (segmentFraction * 0.3) * (_random.nextDouble() - 0.5);
    final desiredFraction =
        (1 - (selectedIndex + 0.5) * segmentFraction + wobble) % 1;
    final currentFraction = state.rotationTurns % 1;
    var deltaFraction = desiredFraction - currentFraction;
    if (deltaFraction <= 0) {
      deltaFraction += 1;
    }

    final spins = 4 + _random.nextInt(2);
    final targetTurns = state.rotationTurns + spins + deltaFraction;
    emit(
      state.copyWith(
        isSpinning: true,
        rotationTurns: targetTurns,
        resetReward: true,
      ),
    );

    await Future<void>.delayed(const Duration(seconds: 3));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final epochDay = _epochDay(today);

    await _isar.writeTxn(() async {
      final player = await _isar.playerDatas.get(1) ?? (PlayerData()..id = 1);
      player.coins += reward;
      player.lastDailyGiftEpochDay = epochDay;
      await _isar.playerDatas.put(player);
    });

    _coinBloc.add(LoadCoins());

    emit(
      state.copyWith(
        isSpinning: false,
        canSpin: false,
        reward: reward,
        lastSpinDate: today,
      ),
    );
  }

  int _epochDay(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;
  }

  DateTime _dateFromEpochDay(int epochDay) {
    return DateTime.fromMillisecondsSinceEpoch(
      epochDay * Duration.millisecondsPerDay,
    );
  }
}