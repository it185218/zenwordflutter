import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/color_library.dart';
import '../../logic/blocs/daily_gift/daily_gift_bloc.dart';
import '../../logic/blocs/daily_gift/daily_gift_event.dart';
import '../../logic/blocs/daily_gift/daily_gift_state.dart';

class DailyGiftWheel extends StatelessWidget {
  const DailyGiftWheel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyGiftBloc, DailyGiftState>(
      listener: (context, state) {
        if (state.reward != null) {
          final reward = state.reward!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You won $reward coins! 🎉'),
              backgroundColor: ColorLibrary.coinContainer,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final canSpin = state.canSpin && !state.isSpinning;
        final rewardText = state.reward != null
            ? 'You received +${state.reward} coins!'
            : canSpin
            ? 'Tap to spin and claim a random coin reward!'
            : 'Come back tomorrow for a new gift.';

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Daily Gift',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorLibrary.dialogText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: canSpin
                  ? () => context
                  .read<DailyGiftBloc>()
                  .add(const SpinDailyGift())
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: 232,
                        height: 232,
                        child: AnimatedRotation(
                          turns: state.rotationTurns,
                          duration: const Duration(seconds: 3),
                          curve: Curves.easeOutQuart,
                          child: CustomPaint(
                            painter: _WheelPainter(state.rewards),
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 62,
                        child: _WheelPointer(),
                      ),
                      _WheelMedallion(
                        isSpinning: state.isSpinning,
                        reward: state.reward,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      state.isSpinning ? 'The wheel is spinning...' : rewardText,
                      key: ValueKey<String>(
                        state.isSpinning
                            ? 'spinning'
                            : state.reward != null
                            ? 'reward-${state.reward}'
                            : 'idle-${state.canSpin}',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ColorLibrary.dialogText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WheelPainter extends CustomPainter {
  _WheelPainter(this.rewards);

  final List<int> rewards;

  static const List<Color> _segmentColors = [
    Color(0xFF1F5361),
    Color(0xFF245E48),
    Color(0xFF713D2A),
    Color(0xFF94652A),
    Color(0xFF2F6D78),
    Color(0xFF4F6A34),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = (2 * pi) / rewards.length;

    final paint = Paint()..style = PaintingStyle.fill;

    final basePaint = Paint()
      ..shader = RadialGradient(
        colors: const [
          Color(0xFF10323E),
          Color(0xFF1E4653),
          Color(0xFF275E68),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(rect);
    canvas.drawCircle(center, radius, basePaint);

    for (int i = 0; i < rewards.length; i++) {
      paint.color = _segmentColors[i % _segmentColors.length];
      final startAngle = (-pi / 2) + (i * sweep);
      canvas.drawArc(rect, startAngle, sweep, true, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '+${rewards[i]}',
          style: const TextStyle(
            color: Color(0xFFFCE7C8),
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      final textAngle = startAngle + sweep / 2;
      final textRadius = radius * 0.6;
      final dx = center.dx + textRadius * cos(textAngle) - textPainter.width / 2;
      final dy = center.dy + textRadius * sin(textAngle) - textPainter.height / 2;
      canvas.save();
      canvas.translate(dx + textPainter.width / 2, dy + textPainter.height / 2);
      canvas.rotate(textAngle);
      canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    final innerBorderPaint = Paint()
      ..shader = SweepGradient(
        colors: const [
          Color(0xFFF8E7C2),
          Color(0xFFD7B676),
          Color(0xFFF8E7C2),
        ],
        startAngle: 0,
        endAngle: 2 * pi,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius * 0.93, innerBorderPaint);

    final rimPaint = Paint()
      ..shader = LinearGradient(
        colors: const [
          Color(0xFF734719),
          Color(0xFFC28D45),
          Color(0xFF734719),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    canvas.drawCircle(center, radius * 0.985, rimPaint);

    final studsPaint = Paint()
      ..color = const Color(0xFFEFD7A3)
      ..style = PaintingStyle.fill;
    final studsRadius = radius * 0.985;
    for (int i = 0; i < rewards.length * 2; i++) {
      final angle = i * (2 * pi / (rewards.length * 2));
      final dx = center.dx + studsRadius * cos(angle);
      final dy = center.dy + studsRadius * sin(angle);
      canvas.drawCircle(Offset(dx, dy), 3.4, studsPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) {
    return oldDelegate.rewards != rewards;
  }
}

class _WheelPointer extends StatelessWidget {
  const _WheelPointer();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(34, 40),
      painter: _PointerPainter(),
    );
  }
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFF5E7C5), Color(0xFFC48A2A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final outline = Paint()
      ..color = const Color(0xFF6A3E13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..quadraticBezierTo(
        size.width * 0.58,
        size.height * 0.18,
        size.width * 0.54,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.52,
        size.height * 0.72,
        size.width * 0.5,
        size.height,
      )
      ..quadraticBezierTo(
        size.width * 0.48,
        size.height * 0.72,
        size.width * 0.46,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.42,
        size.height * 0.18,
        size.width / 2,
        0,
      )
      ..close();

    canvas.drawShadow(path, Colors.black45, 4, true);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, outline);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WheelMedallion extends StatelessWidget {
  const _WheelMedallion({required this.isSpinning, required this.reward});

  final bool isSpinning;
  final int? reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF193741), Color(0xFF204A52), Color(0xFF2C6A70)],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE9D3A2),
          width: 5,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF8A5B26),
            width: 3,
          ),
        ),
        child: Center(
          child: isSpinning
              ? const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF8E7C2)),
            ),
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFF6E3C2),
              ),
              const SizedBox(height: 4),
              Text(
                reward != null ? '+$reward' : 'SPIN',
                style: const TextStyle(
                  color: Color(0xFFF6E3C2),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}