import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/color_library.dart';
import '../../logic/blocs/treasure/treasure_bloc.dart';
import '../../logic/blocs/treasure/treasure_state.dart';

// A page that displays collected vase images in a shelf-like layout.
// Each shelf holds up to 3 vases, with a total of 12 possible vases (4 shelves).
class TreasurePage extends StatelessWidget {
  const TreasurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        leading: IconButton(
          // Custom circular back button
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
          'Θησαυρός',
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
              // Only render when the state is loaded
              if (state is! TreasureLoaded) return const SizedBox.shrink();

              final vaseIndices = state.progress.vaseIndices;

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Divide the vertical space into 6 for visual balance
                  final shelfHeight = constraints.maxHeight / 6;

                  // Create 4 shelves, each holding 3 vases
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (shelfIndex) {
                      final start = shelfIndex * 3;
                      // Extract 3 vases for the current shelf
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
                            // Wooden shelf
                            Image.asset(
                              'assets/images/wood_shelf.png',
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                            // Display the vases above the shelf
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
