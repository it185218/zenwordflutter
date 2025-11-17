import 'package:flutter/material.dart';

import '../../core/utils/color_library.dart';
import 'daily_gift_wheel.dart';

class DailyGiftDialog extends StatelessWidget {
  const DailyGiftDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: ColorLibrary.dialogContainer2,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: ColorLibrary.dialogText),
              ),
            ),
            const DailyGiftWheel(),
          ],
        ),
      ),
    );
  }
}
