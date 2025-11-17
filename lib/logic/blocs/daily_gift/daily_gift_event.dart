import 'package:equatable/equatable.dart';

abstract class DailyGiftEvent extends Equatable {
  const DailyGiftEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyGift extends DailyGiftEvent {
  const LoadDailyGift();
}

class SpinDailyGift extends DailyGiftEvent {
  const SpinDailyGift();
}
