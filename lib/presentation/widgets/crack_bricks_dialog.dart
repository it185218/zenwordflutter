import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/treasure/treasure_bloc.dart';
import '../../logic/blocs/treasure/treasure_event.dart';
import '../../logic/blocs/treasure/treasure_state.dart';

class CrackBricksDialog extends StatefulWidget {
  const CrackBricksDialog({super.key});

  @override
  State<CrackBricksDialog> createState() => _CrackBricksDialogState();
}

class _CrackBricksDialogState extends State<CrackBricksDialog>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    });

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    context.read<TreasureBloc>().add(LoadCrackedBricks());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapBrick(int index, CrackedBricksLoaded state) {
    if (state.cracked[index]) return;

    context.read<TreasureBloc>().add(CrackBrick(brickIndex: index));

    final allPiecesFound = state.pieceIndices.every(
      (i) => i == index || state.cracked[i],
    );

    if (allPiecesFound) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TreasureBloc, TreasureState>(
      builder: (context, state) {
        if (state is CrackedBricksLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CrackedBricksLoaded) {
          if (state.allPiecesFound && !_controller.isAnimating) {
            _controller.forward();
          }

          return Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  opacity: state.allPiecesFound ? 0 : 1,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    itemCount: 12,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) {
                      final isCracked = state.cracked[index];
                      final hasPiece = state.pieceIndices.contains(index);
                      final pieceNumber = state.pieceIndices.indexOf(index) + 1;

                      return GestureDetector(
                        onTap: () => _onTapBrick(index, state),
                        child: Stack(
                          children: [
                            if (!isCracked)
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/images/bricks.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (isCracked)
                              Positioned.fill(
                                child:
                                    hasPiece
                                        ? Image.asset(
                                          'assets/images/vase-pieces/vase-${state.vaseIndex + 1}-$pieceNumber.png',
                                          fit: BoxFit.contain,
                                        )
                                        : const Center(
                                          child: Icon(
                                            Icons.clear,
                                            size: 32,
                                            color: Colors.black45,
                                          ),
                                        ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (state.allPiecesFound)
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Image.asset(
                        'assets/images/vases/vase-${state.vaseIndex + 1}.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
