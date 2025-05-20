import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/color_library.dart';
import '../../logic/blocs/coin/coin_bloc.dart';
import '../../logic/blocs/coin/coin_state.dart';
import '../../logic/blocs/level/level_bloc.dart';
import '../../logic/blocs/level/level_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/crack_bricks_dialog.dart';
import '../widgets/hammer_container.dart';
import '../widgets/level_button.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/top_bar.dart';
import '../widgets/treasure_container.dart';
import 'game_page.dart';
import 'treasure_page.dart';

// Displays the game title, current level button, coin count, and settings icon.
// Animations are used to fade in UI elements after a short delay.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controls the opacity of animated UI elements.
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    // Delay the appearance of UI elements for animation purposes.
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),

        // Displays the top bar with a coin counter using BlocBuilder to react to coin state changes.
        child: BlocBuilder<CoinBloc, CoinState>(
          builder: (context, state) {
            return AnimatedOpacity(
              opacity: _isVisible ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: TopBar(showBackButton: false, coinText: '${state.coins}'),
            );
          },
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12, top: 16),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      children: [
                        // Treasure page navigation
                        TreasureContainer(
                          onTap: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => TreasurePage()),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        // Show brick-cracking dialog
                        HammerContainer(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) => const CrackBricksDialog(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: Text(
              'Λεξόσφαιρα',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 150),
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: Center(
              child: BlocBuilder<LevelBloc, LevelState>(
                builder: (context, state) {
                  return LevelButton(
                    text: 'Επίπεδο ${state.currentLevel}',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GamePage(level: state.currentLevel),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          Spacer(),

          // Show SettingsDialog for allowing multiple solutions
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 8, bottom: 16),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const SettingsDialog(),
                    );
                  },
                  icon: Container(
                    decoration: BoxDecoration(
                      color: ColorLibrary.button,
                      shape: BoxShape.circle,
                    ),
                    width: 50,
                    height: 50,
                    child: Icon(Icons.settings, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
