import 'package:equatable/equatable.dart';

class DailyGiftState extends Equatable {
  const DailyGiftState({
    required this.isLoading,
    required this.canSpin,
    required this.isSpinning,
    required this.rotationTurns,
    this.reward,
    this.lastSpinDate,
    this.rewards = const [25, 50, 75, 100, 150, 200],
  });

  factory DailyGiftState.initial() => const DailyGiftState(
        isLoading: true,
        canSpin: false,
        isSpinning: false,
        rotationTurns: 0,
      );

  final bool isLoading;
  final bool canSpin;
  final bool isSpinning;
  final double rotationTurns;
  final int? reward;
  final DateTime? lastSpinDate;
  final List<int> rewards;

  DailyGiftState copyWith({
    bool? isLoading,
    bool? canSpin,
    bool? isSpinning,
    double? rotationTurns,
    int? reward,
    DateTime? lastSpinDate,
    List<int>? rewards,
    bool resetReward = false,
  }) {
    return DailyGiftState(
      isLoading: isLoading ?? this.isLoading,
      canSpin: canSpin ?? this.canSpin,
      isSpinning: isSpinning ?? this.isSpinning,
      rotationTurns: rotationTurns ?? this.rotationTurns,
      reward: resetReward ? null : (reward ?? this.reward),
      lastSpinDate: lastSpinDate ?? this.lastSpinDate,
      rewards: rewards ?? this.rewards,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        canSpin,
        isSpinning,
        rotationTurns,
        reward,
        lastSpinDate,
        rewards,
      ];
}
