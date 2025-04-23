import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/color_library.dart';
import '../../core/utils/scale_animation_helper.dart';
import '../../logic/blocs/treasure/treasure_bloc.dart';
import '../../logic/blocs/treasure/treasure_state.dart';

class TreasureContainer extends StatefulWidget {
  final VoidCallback? onTap;

  const TreasureContainer({super.key, this.onTap});

  @override
  State<TreasureContainer> createState() => _TreasureContainerState();
}

class _TreasureContainerState extends State<TreasureContainer> {
  double _scale = 1.0;

  void _handleTap() {
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TreasureBloc, TreasureState>(
      builder: (context, state) {
        double progress = 0;
        int collectedInSet = 0;
        int required = 3;

        if (state is TreasureLoaded) {
          final setsCompleted = state.progress.setsCompleted;
          final totalCollected = state.progress.totalCollected;

          int getRequiredForNextSet(int setsCompleted) {
            if (setsCompleted == 0) return 3;
            if (setsCompleted == 1) return 6;
            return 9;
          }

          required = getRequiredForNextSet(setsCompleted);
          final start = [0, 3, 9][setsCompleted];
          collectedInSet = totalCollected - start;

          progress = collectedInSet / required;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTapDown: (details) {
                AnimationHelper.onTapDown(details, (newScale) {
                  setState(() => _scale = newScale);
                });
              },
              onTapUp: (details) {
                AnimationHelper.onTapUp(details, (newScale) {
                  setState(() => _scale = newScale);
                });
                _handleTap();
              },
              onTapCancel: () {
                AnimationHelper.onTapCancel((newScale) {
                  setState(() => _scale = newScale);
                });
              },
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: Container(
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorLibrary.button,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/chest.png'),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 40,
              height: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: ColorLibrary.button,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$collectedInSet / $required',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}
