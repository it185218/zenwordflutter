import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'data/model/level.dart';
import 'data/model/performance.dart';
import 'data/model/player_data.dart';
import 'logic/blocs/coin/coin_bloc.dart';
import 'logic/blocs/coin/coin_event.dart';
import 'logic/blocs/game/game_bloc.dart';
import 'logic/blocs/level/level_bloc.dart';
import 'logic/blocs/level/level_event.dart';
import 'presentation/pages/home_page.dart';

late final Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationSupportDirectory();
  isar = await Isar.open([
    LevelSchema,
    PlayerDataSchema,
    PerformanceSchema,
  ], directory: dir.path);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GameBloc()),
        BlocProvider(create: (_) => LevelBloc(isar)..add(LoadLevels())),
        BlocProvider(create: (_) => CoinBloc(isar)..add(LoadCoins())),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: HomePage(),
    );
  }
}
