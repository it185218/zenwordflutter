import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/coin/coin_bloc.dart';
import '../../logic/blocs/coin/coin_state.dart';
import '../../logic/blocs/level/level_bloc.dart';
import '../../logic/blocs/level/level_state.dart';
import '../widgets/background_scaffold.dart';
import '../widgets/level_button.dart';
import '../widgets/top_bar.dart';
import 'game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isVisible = false;
  bool _allowMultipleSolutions = false;

  @override
  void initState() {
    super.initState();
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
                          builder:
                              (_) => GamePage(
                                level: state.currentLevel,
                                allowMultipleSolutions: _allowMultipleSolutions,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 80),
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(seconds: 1),
            child: CheckboxListTile(
              title: Text("Allow same-length subwords"),
              value: _allowMultipleSolutions,
              onChanged: (bool? value) {
                setState(() {
                  _allowMultipleSolutions = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
