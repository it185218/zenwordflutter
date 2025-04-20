import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/color_library.dart';
import '../../logic/blocs/treasure/treasure_bloc.dart';
import '../../logic/blocs/treasure/treasure_state.dart';

class TreasurePage extends StatelessWidget {
  const TreasurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ColorLibrary.button,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Treasures',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<TreasureBloc, TreasureState>(
            builder: (context, state) {
              if (state is! TreasureLoaded) return const SizedBox.shrink();

              final vaseIndices = state.progress.vaseIndices;

              return LayoutBuilder(
                builder: (context, constraints) {
                  final shelfHeight = constraints.maxHeight / 6;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (shelfIndex) {
                      final start = shelfIndex * 3;
                      final vasesForShelf =
                          vaseIndices
                              .skip(start)
                              .take(3)
                              .map(
                                (index) => Image.asset(
                                  'assets/images/vases/vase-${index + 1}.png',
                                  width: 60,
                                  height: 60,
                                ),
                              )
                              .toList();

                      return SizedBox(
                        height: shelfHeight,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/images/wood_shelf.png',
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                            Transform.translate(
                              offset: const Offset(0, -35),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: vasesForShelf,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
