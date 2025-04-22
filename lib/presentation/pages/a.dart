// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:zenwordflutter/data/model/treasure_progress.dart';

// import '../../logic/blocs/treasure/treasure_bloc.dart';
// import '../../logic/blocs/treasure/treasure_state.dart';
// import '../pages/treasure_page.dart';

// class CrackBricksDialog extends StatefulWidget {
//   const CrackBricksDialog({super.key});

//   @override
//   State<CrackBricksDialog> createState() => _CrackBricksDialogState();
// }

// class _CrackBricksDialogState extends State<CrackBricksDialog>
//     with TickerProviderStateMixin {
//   late final AnimationController _hammerController;
//   late final AnimationController _vaseController;
//   late final AnimationController _brickShakeController;

//   bool _bricksCracked = false;
//   bool _hasCracked = false;

//   @override
//   void initState() {
//     super.initState();

//     _hammerController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );

//     _brickShakeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     _vaseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );

//     final treasureBloc = context.read<TreasureBloc>();
//     final progress = treasureBloc.state;

//     if (progress is TreasureLoaded) {
//       final currentSet = progress.progress.setsCompleted;
//       final alreadyCracked = progress.progress.lastCrackedSet >= currentSet;

//       if (alreadyCracked) {
//         Future.microtask(() {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (_) => const TreasurePage()),
//           );
//         });
//         return;
//       }

//       // Schedule animations
//       Future.delayed(const Duration(milliseconds: 800), () {
//         _hammerController.forward();

//         _brickShakeController.forward();

//         Future.delayed(const Duration(milliseconds: 700), () {
//           setState(() {
//             _bricksCracked = true;
//           });

//           Future.delayed(const Duration(milliseconds: 300), () {
//             _vaseController.forward();
//           });

//           Future.delayed(const Duration(seconds: 2), () async {
//             if (mounted && !_hasCracked) {
//               setState(() {
//                 _hasCracked = true;
//               });

//               final updated = progress.progress;
//               updated.lastCrackedSet = currentSet;
//               await treasureBloc.isar.writeTxn(
//                 () => treasureBloc.isar.treasureProgress.put(updated),
//               );

//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (_) => const TreasurePage()),
//               );
//             }
//           });
//         });
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _hammerController.dispose();
//     _vaseController.dispose();
//     _brickShakeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final progress = context.watch<TreasureBloc>().state;
//     int vaseIndex =
//         progress is TreasureLoaded && progress.progress.vaseIndices.isNotEmpty
//             ? progress.progress.vaseIndices.last
//             : -1;

//     final brickShake = TweenSequence<Offset>([
//       TweenSequenceItem(
//         tween: Tween(begin: Offset.zero, end: const Offset(0.02, 0)),
//         weight: 1,
//       ),
//       TweenSequenceItem(
//         tween: Tween(begin: const Offset(0.02, 0), end: const Offset(-0.02, 0)),
//         weight: 1,
//       ),
//       TweenSequenceItem(
//         tween: Tween(begin: const Offset(-0.02, 0), end: Offset.zero),
//         weight: 1,
//       ),
//     ]).animate(_brickShakeController);

//     final hammerAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: const Offset(0, -1.5),
//     ).animate(
//       CurvedAnimation(parent: _hammerController, curve: Curves.easeInOutBack),
//     );

//     final vaseScale = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _vaseController, curve: Curves.elasticOut),
//     );

//     return Material(
//       color: Colors.transparent,
//       child: Center(
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             if (!_bricksCracked)
//               SlideTransition(
//                 position: brickShake,
//                 child: Image.asset('assets/images/bricks.png', height: 200),
//               ),
//             if (_bricksCracked)
//               FadeTransition(
//                 opacity: _vaseController,
//                 child: ScaleTransition(
//                   scale: vaseScale,
//                   child:
//                       vaseIndex != -1
//                           ? Image.asset(
//                             'assets/images/vases/vase-${vaseIndex + 1}.png',
//                             height: 200,
//                           )
//                           : const SizedBox(),
//                 ),
//               ),
//             SlideTransition(
//               position: hammerAnimation,
//               child: Image.asset('assets/images/hammer.png', height: 100),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
