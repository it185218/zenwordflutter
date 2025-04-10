import 'package:flutter/material.dart';
import '../../core/utils/color_library.dart';

class CoinContainer extends StatelessWidget {
  final String text;

  const CoinContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          children: [
            const SizedBox(width: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorLibrary.coinContainer,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorLibrary.coinText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Circle overlapping the left edge
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: ColorLibrary.coin,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(), // You can add content here if needed
            ),
          ),
        ),
      ],
    );
  }
}
