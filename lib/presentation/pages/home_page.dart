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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<CoinBloc, CoinState>(
          builder: (context, state) {
            return TopBar(showBackButton: false, coinText: '${state.coins}');
          },
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'PUZZLE GAME',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 150),
          Center(
            child: BlocBuilder<LevelBloc, LevelState>(
              builder: (context, state) {
                return LevelButton(
                  text: 'Level ${state.currentLevel}',
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
        ],
      ),
    );
  }
}
