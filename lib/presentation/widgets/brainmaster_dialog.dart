import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/color_library.dart';
import '../../data/local/brainmaster_storage.dart';
import '../../logic/blocs/coin/coin_bloc.dart';
import '../../logic/blocs/coin/coin_event.dart';

class BrainmasterDialog extends StatefulWidget {
  const BrainmasterDialog({super.key});

  @override
  State<BrainmasterDialog> createState() => _BrainmasterDialogState();
}

class _BrainmasterDialogState extends State<BrainmasterDialog> {
  BrainmasterData? _data;
  bool _loading = true;
  Timer? _timer;
  Duration? _timeUntilReset;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    final data = await BrainmasterStorage.instance.load();
    if (!mounted) return;
    setState(() {
      _data = data;
      _loading = false;
    });
    _startCountdown();
  }

  Future<void> _claimReward(int index, _Reward reward) async {
    final current = _data;
    if (current == null) return;

    final unlocked = current.wordsFound >= reward.requiredWords;
    final claimed = current.isRewardClaimed(index);
    if (!unlocked || claimed) return;

    var updated = current.markClaimed(index);
    String message;

    if (reward.type == _RewardType.coins) {
      context.read<CoinBloc>().add(AddCoins(reward.amount));
      message = 'Έλαβες ${reward.amount} κέρματα!';
    } else {
      updated = updated.copyWith(freeHints: updated.freeHints + reward.amount);
      message = reward.amount == 1
          ? 'Έλαβες 1 δωρεάν συμβουλή!'
          : 'Έλαβες ${reward.amount} δωρεάν συμβουλές!';
    }

    await BrainmasterStorage.instance.overwrite(updated);
    if (!mounted) return;
    setState(() {
      _data = updated;
    });
    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _startCountdown() {
    _timer?.cancel();
    final data = _data;
    if (data == null) return;

    void updateRemaining() {
      final nextReset = data.lastResetAt.add(const Duration(hours: 24));
      final diff = nextReset.difference(DateTime.now());
      final remaining = diff.isNegative ? Duration.zero : diff;
      if (mounted) {
        setState(() {
          _timeUntilReset = remaining;
        });
      }
    }

    updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => updateRemaining());
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ColorLibrary.dialogContainer1.withOpacity(0.95),
                  ColorLibrary.dialogContainer3.withOpacity(0.95),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(80, 0, 0, 0),
                  blurRadius: 14,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(26, 48, 26, 26),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_loading && _timeUntilReset != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _ResetTimerLabel(remaining: _timeUntilReset!),
                    ),
                  if (!_loading && _timeUntilReset != null)
                    const SizedBox(height: 8),
                  const _DialogTitle(),
                  const SizedBox(height: 10),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: CircularProgressIndicator(),
                    )
                  else if (data != null) ...[
                    _UnlockNote(wordsFound: data.wordsFound),
                    const SizedBox(height: 22),
                    _RewardGrid(
                      data: data,
                      onRewardTap: _claimReward,
                    ),
                    const SizedBox(height: 18),
                    _FooterHint(freeHints: data.freeHints),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            right: -4,
            top: -4,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              splashRadius: 24,
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ColorLibrary.button.withOpacity(0.65),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorLibrary.buttonBorder.withOpacity(0.9),
                    width: 1.6,
                  ),
                ),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const List<_Reward> _rewards = [
  _Reward(
    icon: Icons.monetization_on,
    title: 'Κέρματα',
    amount: 25,
    requiredWords: 3,
    type: _RewardType.coins,
  ),
  _Reward(
    icon: Icons.lightbulb_outline,
    title: 'Συμβουλές',
    amount: 1,
    requiredWords: 6,
    type: _RewardType.hints,
  ),
  _Reward(
    icon: Icons.monetization_on,
    title: 'Κέρματα',
    amount: 50,
    requiredWords: 9,
    type: _RewardType.coins,
  ),
  _Reward(
    icon: Icons.lightbulb_outline,
    title: 'Συμβουλές',
    amount: 1,
    requiredWords: 12,
    type: _RewardType.hints,
  ),
  _Reward(
    icon: Icons.monetization_on,
    title: 'Κέρματα',
    amount: 100,
    requiredWords: 15,
    type: _RewardType.coins,
  ),
  _Reward(
    icon: Icons.lightbulb_outline,
    title: 'Συμβουλές',
    amount: 1,
    requiredWords: 18,
    type: _RewardType.hints,
  ),
  _Reward(
    icon: Icons.monetization_on,
    title: 'Κέρματα',
    amount: 150,
    requiredWords: 21,
    type: _RewardType.coins,
  ),
  _Reward(
    icon: Icons.lightbulb_outline,
    title: 'Συμβουλές',
    amount: 2,
    requiredWords: 24,
    type: _RewardType.hints,
  ),
  _Reward(
    icon: Icons.monetization_on,
    title: 'Κέρματα',
    amount: 200,
    requiredWords: 27,
    type: _RewardType.coins,
  ),
  _Reward(
    icon: Icons.lightbulb_outline,
    title: 'Συμβουλές',
    amount: 3,
    requiredWords: 30,
    type: _RewardType.hints,
  ),
];

enum _RewardType { coins, hints }

class _Reward {
  final IconData icon;
  final String title;
  final int amount;
  final int requiredWords;
  final _RewardType type;

  const _Reward({
    required this.icon,
    required this.title,
    required this.amount,
    required this.requiredWords,
    required this.type,
  });

  String get label => '+$amount';
}

class _RewardGrid extends StatelessWidget {
  final BrainmasterData data;
  final void Function(int, _Reward) onRewardTap;

  const _RewardGrid({
    required this.data,
    required this.onRewardTap,
  });

  @override
  Widget build(BuildContext context) {
    const columns = 2;
    const spacing = 16.0;
    const totalSpacing = spacing * (columns - 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 52;
        final tentativeWidth = (maxWidth - totalSpacing) / columns;
        final cardWidth = tentativeWidth > 0 ? tentativeWidth : maxWidth / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 18,
          children: List.generate(_rewards.length, (index) {
            final reward = _rewards[index];
            final unlocked = data.wordsFound >= reward.requiredWords;
            final claimed = data.isRewardClaimed(index);
            final enabled = unlocked && !claimed;

            return SizedBox(
              width: cardWidth,
              child: _RewardCard(
                reward: reward,
                unlocked: unlocked,
                claimed: claimed,
                wordsFound: data.wordsFound,
                onTap: enabled ? () => onRewardTap(index, reward) : null,
              ),
            );
          }),
        );
      },
    );
  }
}

class _RewardCard extends StatelessWidget {
  final _Reward reward;
  final bool unlocked;
  final bool claimed;
  final int wordsFound;
  final VoidCallback? onTap;

  const _RewardCard({
    required this.reward,
    required this.unlocked,
    required this.claimed,
    required this.wordsFound,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        '${wordsFound.clamp(0, reward.requiredWords)}/${reward.requiredWords} λέξεις';
    final statusText = claimed
        ? 'Συλλέχθηκε'
        : unlocked
        ? 'Πάτησε για να το συλλέξεις'
        : 'Ξεκλειδώνει στις ${reward.requiredWords} λέξεις';

    final backgroundOpacity = claimed
        ? 0.65
        : unlocked
        ? 0.95
        : 0.75;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(backgroundOpacity),
              Colors.white.withOpacity(backgroundOpacity - 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: claimed
                ? ColorLibrary.buttonBorder.withOpacity(0.4)
                : ColorLibrary.buttonBorder.withOpacity(0.8),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(40, 0, 0, 0),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              reward.title,
              style: const TextStyle(
                color: ColorLibrary.dialogText,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: claimed
                    ? ColorLibrary.button.withOpacity(0.35)
                    : ColorLibrary.button.withOpacity(0.85),
                border: Border.all(color: ColorLibrary.buttonBorder, width: 1.2),
              ),
              child: Icon(
                reward.icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              reward.label,
              style: const TextStyle(
                color: Color(0xFF39504B),
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              progress,
              style: const TextStyle(
                color: Color(0xFF2E4A46),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              statusText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: claimed
                    ? const Color(0xFF2E4A46).withOpacity(0.7)
                    : const Color(0xFF2E4A46),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogTitle extends StatelessWidget {
  const _DialogTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Brain Master',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.4,
            color: ColorLibrary.dialogText,
          ),
        ),
      ],
    );
  }
}

class _UnlockNote extends StatelessWidget {
  final int wordsFound;

  const _UnlockNote({required this.wordsFound});

  @override
  Widget build(BuildContext context) {
    _Reward? nextReward;
    for (final reward in _rewards) {
      if (wordsFound < reward.requiredWords) {
        nextReward = reward;
        break;
      }
    }

    final description = nextReward == null
        ? 'Έχεις ξεκλειδώσει όλες τις ανταμοιβές αυτής της ενότητας!'
        : 'Βρες ακόμη ${nextReward.requiredWords - wordsFound} λέξεις για την επόμενη ανταμοιβή.';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ColorLibrary.buttonBorder.withOpacity(0.7),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Λέξεις που βρέθηκαν: $wordsFound',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF2E4A46),
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF2E4A46),
              fontSize: 13,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterHint extends StatelessWidget {
  final int freeHints;

  const _FooterHint({required this.freeHints});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: ColorLibrary.backgroundOverlay,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(Icons.info_outline, size: 18, color: Color(0xFF2E4A46)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              freeHints == 0
                  ? 'Κέρδισε συμβουλές για δωρεάν χρήση μέσα στο παιχνίδι.'
                  : 'Διαθέσιμες δωρεάν συμβουλές: $freeHints',
              style: const TextStyle(
                color: Color(0xFF2E4A46),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResetTimerLabel extends StatelessWidget {
  final Duration remaining;

  const _ResetTimerLabel({required this.remaining});

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorLibrary.buttonBorder.withOpacity(0.6),
          width: 0.9,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.timer_outlined,
            size: 14,
            color: ColorLibrary.dialogText,
          ),
          const SizedBox(width: 6),
          Text(
            'Επαναφορά σε ${_formatDuration(remaining)}',
            style: const TextStyle(
              color: ColorLibrary.dialogText,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}