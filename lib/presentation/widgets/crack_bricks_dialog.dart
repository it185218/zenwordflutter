import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:zenwordflutter/data/model/treasure_progress.dart';

import '../../core/utils/color_library.dart';
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

  Offset? _hammerPosition;
  late AnimationController _hammerController;
  late Animation<double> _hammerScale;
  late Animation<double> _hammerRotation;

  final List<GlobalKey> _brickKeys = List.generate(12, (_) => GlobalKey());
  final GlobalKey _stackKey = GlobalKey();

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

    _hammerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _hammerScale = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(parent: _hammerController, curve: Curves.elasticOut),
    );

    _hammerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _hammerPosition = null;
            });
          }
        });
      }
    });

    _hammerRotation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: -0.4, end: 0.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 0.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _hammerController, curve: Curves.easeOutCubic),
    );

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
    _hammerController.dispose();
    super.dispose();
  }

  void _onTapBrick(int index, CrackedBricksLoaded state) async {
    if (state.cracked[index]) return;

    final isar = Isar.getInstance();
    final progress = await isar?.treasureProgress.where().findFirst();

    if (progress == null || progress.totalHammers <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Not enough hammer!")));
      return;
    }

    final brickContext = _brickKeys[index].currentContext;
    final stackContext = _stackKey.currentContext;

    if (brickContext != null && stackContext != null) {
      final brickBox = brickContext.findRenderObject() as RenderBox;
      final stackBox = stackContext.findRenderObject() as RenderBox;

      final brickGlobal = brickBox.localToGlobal(Offset.zero);
      final stackGlobal = stackBox.localToGlobal(Offset.zero);

      final offsetInStack = brickGlobal - stackGlobal;
      final brickSize = brickBox.size;

      setState(() {
        _hammerPosition =
            offsetInStack +
            Offset(brickSize.width / 2 - 24, brickSize.height / 2 - 24);
      });

      _hammerController.forward(from: 0);

      _hammerController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              setState(() {
                _hammerPosition = null;
              });

              context.read<TreasureBloc>().add(CrackBrick(brickIndex: index));

              final allPiecesFound = state.pieceIndices.every(
                (i) => i == index || state.cracked[i],
              );

              if (allPiecesFound) {
                _controller.forward();
              }
            }
          });
        }
      });
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
            backgroundColor: ColorLibrary.bricksBackground,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, top: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorLibrary.dialogContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/hammer.png',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${state.totalHammers}',
                            style: const TextStyle(
                              color: ColorLibrary.dialogText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Stack(
                  key: _stackKey,
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
                          final pieceNumber =
                              state.pieceIndices.indexOf(index) + 1;

                          return GestureDetector(
                            onTap: () {
                              if (state.cracked[index]) return;

                              _onTapBrick(index, state);
                            },

                            child: Stack(
                              key: _brickKeys[index],
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
                                                color: ColorLibrary.dialogText,
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
                    if (_hammerPosition != null)
                      Positioned(
                        left: _hammerPosition!.dx,
                        top: _hammerPosition!.dy,
                        child: RotationTransition(
                          turns: _hammerRotation,
                          child: ScaleTransition(
                            scale: _hammerScale,
                            child: Image.asset(
                              'assets/images/hammer.png',
                              width: 48,
                              height: 48,
                            ),
                          ),
                        ),
                      ),
                  ],
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
