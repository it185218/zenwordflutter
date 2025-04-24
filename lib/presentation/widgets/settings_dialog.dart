import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/color_library.dart';
import '../../logic/blocs/game/game_bloc.dart';
import '../../logic/blocs/game/game_event.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameBloc>().state;
    final currentSetting = gameState.allowMultipleSolutions;

    return AlertDialog(
      backgroundColor: ColorLibrary.dialogContainer3,
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorLibrary.dialogContainer2,
                ),
                child: Icon(
                  Icons.close,
                  color: ColorLibrary.dialogText,
                  size: 20,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: const Text(
              'Ρυθμίσεις',
              style: TextStyle(color: ColorLibrary.dialogText),
            ),
          ),
        ],
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(
            'Επιτρεπονται παραγωγα ιδιου αριθμου γραμματων με την λεξη-ριζα;',
            style: TextStyle(
              color: ColorLibrary.dialogText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            activeColor: ColorLibrary.background,
            title: const Text(
              'Επιτρέπονται',
              style: TextStyle(color: ColorLibrary.dialogText, fontSize: 12),
            ),
            value: currentSetting,
            onChanged: (value) {
              context.read<GameBloc>().add(GameSettingChanged(true));
            },
          ),
          CheckboxListTile(
            activeColor: ColorLibrary.background,
            title: const Text(
              'Δεν επιτρέπονται',
              style: TextStyle(color: ColorLibrary.dialogText, fontSize: 12),
            ),
            value: !currentSetting,
            onChanged: (value) {
              context.read<GameBloc>().add(GameSettingChanged(false));
            },
          ),
        ],
      ),
    );
  }
}
