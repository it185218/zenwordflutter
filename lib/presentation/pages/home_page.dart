import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/blocs/coin/coin_bloc.dart';
import '../../logic/blocs/coin/coin_state.dart';
import '../../logic/blocs/level/level_bloc.dart';
import '../../logic/blocs/level/level_state.dart';
import '../widgets/background_scaffold.dart';
import 'game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Word Game'),
            BlocBuilder<CoinBloc, CoinState>(
              builder: (context, state) {
                return Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${state.coins}'),
                  ],
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      child: Center(
        child: BlocBuilder<LevelBloc, LevelState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GamePage(level: state.currentLevel),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text('Play Level ${state.currentLevel}'),
            );
          },
        ),
      ),
    );
  }
}
