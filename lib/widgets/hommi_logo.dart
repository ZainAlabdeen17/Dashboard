import 'package:flutter/material.dart';

class HommiLogo extends StatelessWidget {
  final double? size;
  final bool showSubtitle;

  const HommiLogo({super.key, this.size, this.showSubtitle = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // House Icon
        CustomPaint(
          size: Size(size ?? 60, size ?? 60),
          painter: _HousePainter(),
        ),
        const SizedBox(width: 15),
        // Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'HOMMI',
              style: TextStyle(
                fontSize: (size ?? 60) * 0.6,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 2,
              ),
            ),
            if (showSubtitle)
              Text(
                'RENTAL HOUSING',
                style: TextStyle(
                  fontSize: (size ?? 60) * 0.25,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                  letterSpacing: 1,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _HousePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final windowPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // House body (square)
    final bodySize = size.width * 0.7;
    final bodyLeft = (size.width - bodySize) / 2;
    final bodyTop = size.height * 0.3;
    final bodyRect = Rect.fromLTWH(bodyLeft, bodyTop, bodySize, bodySize);

    // Draw house body outline
    canvas.drawRect(bodyRect, paint);

    // Draw roof (triangle)
    final roofTop = bodyTop;
    final roofLeft = bodyLeft;
    final roofRight = bodyLeft + bodySize;
    final roofBottom = bodyTop;
    final path = Path()
      ..moveTo(roofLeft, roofBottom)
      ..lineTo(roofLeft + bodySize / 2, roofTop - bodySize * 0.3)
      ..lineTo(roofRight, roofBottom)
      ..close();
    canvas.drawPath(path, paint);

    // Draw windows (2x2 grid inside the body)
    final windowSize = bodySize * 0.25;
    final windowSpacing = bodySize * 0.15;
    final startX = bodyLeft + windowSpacing;
    final startY = bodyTop + windowSpacing;

    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 2; col++) {
        final windowX = startX + col * (windowSize + windowSpacing);
        final windowY = startY + row * (windowSize + windowSpacing);
        canvas.drawRect(
          Rect.fromLTWH(windowX, windowY, windowSize, windowSize),
          windowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
