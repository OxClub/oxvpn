import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class WorldMapPainter extends CustomPainter {
  const WorldMapPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF6E2B26);
    const step = 9.0;
    for (double y = 0; y < size.height; y += step) {
      for (double x = 0; x < size.width; x += step) {
        final nx = x / size.width, ny = y / size.height;
        final land = (ny > 0.28 && ny < 0.72) &&
            (nx < 0.26 || (nx > 0.34 && nx < 0.60) || (nx > 0.66 && nx < 0.94));
        if (land) canvas.drawCircle(Offset(x, y), 1.1, paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
