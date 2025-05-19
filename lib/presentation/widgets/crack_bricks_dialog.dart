import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenwordflutter/data/model/treasure_progress.dart';

import '../../logic/blocs/treasure/treasure_bloc.dart';
import '../../logic/blocs/treasure/treasure_state.dart';
import '../pages/treasure_page.dart';

class CrackBricksDialog extends StatefulWidget {
  const CrackBricksDialog({super.key});

  @override
  State<CrackBricksDialog> createState() => _CrackBricksDialogState();
}

class _CrackBricksDialogState extends State<CrackBricksDialog>
    with TickerProviderStateMixin {
  bool _bricksCracked = false;
  bool _hasCracked = false;

  late AnimationController _hammerController;
  late Animation<double> _hammerRotation;
  late Animation<Offset> _hammerOffset;
  late Animation<double> _hammerOpacity;

  late AnimationController _brickShakeController;
  late Animation<double> _brickShake;

  late AnimationController _vaseScaleController;
  late Animation<double> _vaseScale;

  @override
  void initState() {
    super.initState();

    _hammerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _hammerRotation = ClampedAnimation(
      TweenSequence([
        TweenSequenceItem(
          tween: Tween(
            begin: 0.0,
            end: -0.6,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 2,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: -0.6,
            end: 1.2,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 4,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 1.2,
            end: 0.0,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 1,
        ),
      ]),
    ).animate(_hammerController);

    _hammerOffset = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(0, -0.2)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, -0.2), end: const Offset(0, 0.1)),
        weight: 4,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0.1), end: Offset.zero),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(parent: _hammerController, curve: Curves.easeInOut),
    );

    _hammerOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _hammerController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _brickShakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _brickShake = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _brickShakeController, curve: Curves.elasticIn),
    );

    _vaseScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _vaseScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _vaseScaleController, curve: Curves.easeOutBack),
    );

    final treasureBloc = context.read<TreasureBloc>();
    final progress = treasureBloc.state;

    if (progress is TreasureLoaded) {
      final currentSet = progress.progress.setsCompleted;
      final alreadyCracked = progress.progress.lastCrackedSet >= currentSet;

      if (alreadyCracked) {
        Future.microtask(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const TreasurePage()),
          );
        });
        return;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        _hammerController.forward().whenComplete(() async {
          await Future.delayed(const Duration(milliseconds: 200));
          _brickShakeController.forward().whenComplete(() {
            setState(() {
              _bricksCracked = true;
            });
            _vaseScaleController.forward();

            Future.delayed(const Duration(seconds: 2), () async {
              if (mounted && !_hasCracked) {
                setState(() {
                  _hasCracked = true;
                });

                final updated = progress.progress;
                updated.lastCrackedSet = currentSet;
                await treasureBloc.isar.writeTxn(
                  () => treasureBloc.isar.treasureProgress.put(updated),
                );

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const TreasurePage()),
                );
              }
            });
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _hammerController.dispose();
    _brickShakeController.dispose();
    _vaseScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<TreasureBloc>().state;
    int vaseIndex =
        progress is TreasureLoaded && progress.progress.vaseIndices.isNotEmpty
            ? progress.progress.vaseIndices.last
            : -1;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!_bricksCracked)
              AnimatedBuilder(
                animation: _brickShakeController,
                builder: (_, child) {
                  return Transform.translate(
                    offset: Offset(
                      _brickShake.value * (math.Random().nextBool() ? 1 : -1),
                      0,
                    ),
                    child: child,
                  );
                },
                child: Image.asset('assets/images/bricks.png', height: 200),
              ),

            if (_bricksCracked && vaseIndex != -1)
              AnimatedBuilder(
                animation: _vaseScaleController,
                builder: (_, __) {
                  return Transform.scale(
                    scale: _vaseScale.value,
                    child: Image.asset(
                      'assets/images/vases/vase-${vaseIndex + 1}.png',
                      height: 200,
                    ),
                  );
                },
              ),

            AnimatedBuilder(
              animation: _hammerController,
              builder: (_, child) {
                return SlideTransition(
                  position: _hammerOffset,
                  child: Transform.rotate(
                    angle: _hammerRotation.value,
                    child: FadeTransition(
                      opacity: _hammerOpacity,
                      child: child,
                    ),
                  ),
                );
              },
              child: Image.asset('assets/images/hammer.png', height: 140),
            ),
          ],
        ),
      ),
    );
  }
}

class ClampedAnimation extends Animatable<double> {
  final Animatable<double> tween;

  ClampedAnimation(this.tween);

  @override
  double transform(double t) {
    return tween.transform(t.clamp(0.0, 1.0));
  }
}
