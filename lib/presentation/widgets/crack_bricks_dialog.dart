import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:zenwordflutter/data/model/cracked_bricks.dart';

import '../../logic/blocs/treasure/treasure_bloc.dart';
import '../../logic/blocs/treasure/treasure_state.dart';

class CrackBricksDialog extends StatefulWidget {
  const CrackBricksDialog({super.key});

  @override
  State<CrackBricksDialog> createState() => _CrackBricksDialogState();
}

class _CrackBricksDialogState extends State<CrackBricksDialog>
    with TickerProviderStateMixin {
  List<bool> cracked = List.filled(12, false);
  List<int> pieceIndices = [];
  late int vaseIndex;
  late int setIndex;
  bool loading = true;
  bool allPiecesFound = false;
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

    _loadData();
  }

  Future<void> _loadData() async {
    final bloc = context.read<TreasureBloc>();
    final progress = bloc.state;

    if (progress is! TreasureLoaded) return;

    // Iterate over all possible set indices (0 to 11 max)
    for (int i = 0; i < 12; i++) {
      final crackedEntry =
          await bloc.isar.crackedBricks.filter().setIndexEqualTo(i).findFirst();

      if (crackedEntry != null) {
        final revealedAll = crackedEntry.pieceIndices.every(
          (j) => crackedEntry.crackedStates[j],
        );
        if (!revealedAll) {
          setIndex = i;
          vaseIndex = i;
          cracked = List.from(crackedEntry.crackedStates);
          pieceIndices = List.from(crackedEntry.pieceIndices);
          setState(() => loading = false);
          return;
        }
      } else {
        setIndex = i;
        vaseIndex = i;
        final indices = List.generate(12, (i) => i)..shuffle();
        pieceIndices = indices.take(4).toList();
        cracked = List.filled(12, false);

        final entry =
            CrackedBricks(setIndex: i)
              ..crackedStates = cracked
              ..pieceIndices = pieceIndices;

        await bloc.isar.writeTxn(() async {
          await bloc.isar.crackedBricks.put(entry);
        });

        setState(() => loading = false);
        return;
      }
    }

    setState(() => loading = false);
  }

  Future<void> _onTapBrick(int index) async {
    if (cracked[index]) return;

    setState(() {
      cracked[index] = true;
    });

    final bloc = context.read<TreasureBloc>();
    final entry =
        await bloc.isar.crackedBricks
            .filter()
            .setIndexEqualTo(setIndex)
            .findFirst();

    if (entry != null) {
      entry.crackedStates[index] = true;
      await bloc.isar.writeTxn(() async {
        await bloc.isar.crackedBricks.put(entry);
      });
    }

    final revealedAll = pieceIndices.every((i) => cracked[i]);
    if (revealedAll && !allPiecesFound) {
      setState(() {
        allPiecesFound = true;
      });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🧱 Bricks grid (hide with opacity when complete)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: allPiecesFound ? 0 : 1,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final isCracked = cracked[index];
                final hasPiece = pieceIndices.contains(index);
                final pieceNumber = pieceIndices.indexOf(index) + 1;

                return GestureDetector(
                  onTap: () => _onTapBrick(index),
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
                                    'assets/images/vase-pieces/vase-${vaseIndex + 1}-$pieceNumber.png',
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

          // 🏺 Full Vase Animation
          if (allPiecesFound)
            ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/images/vases/vase-${vaseIndex + 1}.png',
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
}
