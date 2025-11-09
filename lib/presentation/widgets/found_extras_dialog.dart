import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenwordflutter/core/utils/color_library.dart';
import '../../logic/blocs/game/game_bloc.dart';
import '../../logic/blocs/game/game_state.dart';

class FoundExtrasDialog extends StatelessWidget {
  const FoundExtrasDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: math.min(MediaQuery.of(context).size.width * 0.9, 350),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColorLibrary.dialogContainer,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              final foundExtras = state.foundExtras;
              final totalGlobal = state.totalFoundExtras;

              // Calculate the progress toward the next reward
              final progressToNextReward =
                  (totalGlobal % 10); // Progress towards the next set of 10

              // Calculate the fraction of the next milestone (0/10, 1/10, etc.)
              final progress = progressToNextReward / 10.0;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorLibrary.dialogContainer1,
                        ),
                        child: Icon(
                          Icons.close,
                          color: ColorLibrary.dialogText,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  Text(
                    'Extra λέξεις',
                    style: TextStyle(
                      color: ColorLibrary.dialogText,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 8),

                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ColorLibrary.dialogContainer1,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            SizedBox(
                              height: 16,
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 12,
                                backgroundColor:
                                    ColorLibrary.progressBackground,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorLibrary.progress,
                                ),
                                color: ColorLibrary.progress,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                '$progressToNextReward / 10',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${10 - progressToNextReward} εμειναν για να κερδίσετε ανταμοιβή!!',
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColorLibrary.dialogText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        Divider(
                          color: ColorLibrary.progressBackground,
                          thickness: 0 / 5,
                          height: 32,
                        ),

                        Container(
                          decoration: BoxDecoration(
                            color: ColorLibrary.dialogContainer2,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorLibrary.dialogContainer3,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Βρέθηκαν σε αυτό το επίπεδο',
                                      style: const TextStyle(
                                        color: ColorLibrary.dialogText,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              foundExtras.isEmpty
                                  ? const Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Text(
                                        "Δεν βρέθηκαν άλλες λέξεις ακόμα",
                                        style: TextStyle(
                                          color: ColorLibrary.dialogText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                  : Container(
                                    constraints: BoxConstraints(maxHeight: 200),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: ColorLibrary.dialogContainer2,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children:
                                            foundExtras
                                                .map(
                                                  (word) => Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 8,
                                                        ),
                                                    child: Text(
                                                      word,
                                                      style: const TextStyle(
                                                        color:
                                                            ColorLibrary
                                                                .dialogText,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
