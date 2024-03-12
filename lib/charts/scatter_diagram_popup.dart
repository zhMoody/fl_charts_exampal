import "package:flutter/material.dart";
import "package:flutter_example/base_painter.dart";
import "package:flutter_example/extension.dart";

const kPadding = 16.0;
const kRadius = 4.0;

class ScatterDiagramPopup {
  static int find(double base, List<double> numbers, double threshold) {
    var ret = (numbers.first, 0);
    var diff = (base - ret.$1).abs();
    numbers.forEachI((n, i) {
      final d = (base - n).abs();
      if (d < diff && d <= threshold) {
        ret = (n, i);
        diff = d;
      }
    });
    return diff > threshold ? -1 : ret.$2;
  }

  static void draw({
    required Canvas canvas,
    required Positions positions,
    required Size size,
    required List<(Offset, double, String)> points,
  }) {
    if (positions.global == null || positions.local == null) {
      return;
    }
    final localDx = positions.local!.dx - kPadding;
    final dy = (size.height + 60);
    final index =
        find(localDx, points.map((e) => e.$1.dx).toList(), kRadius * 3);

    if (index != -1) {
      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      final paint = Paint();

      final point = points[index];
      final text = TextSpan(
        text: point.$3,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.text = text;
      textPainter.layout();

      final textSize = textPainter.size;
      final dx = point.$1.dx;
      final textOffset = Offset(dx - textSize.width / 2 + kPadding, -dy * 0.3);

      final center = Offset(dx + kPadding, textSize.height * 0.5 - dy * 0.3);
      final rect = Rect.fromCenter(
          center: center,
          width: textSize.width + 15,
          height: textSize.height + 8);

      const triangleHeight = 5.0;
      const triangleWidth = 12.0;

      final trianglePath = Path()
        ..moveTo(center.dx - triangleWidth / 2, rect.bottom)
        ..lineTo(center.dx, rect.bottom + triangleHeight)
        ..lineTo(center.dx + triangleWidth / 2, rect.bottom)
        ..close();

      final path = Path()
        ..addRRect(RRect.fromRectAndRadius(
            rect, Radius.circular((textSize.height + 8) / 2)))
        ..addPath(trianglePath, Offset.zero);
      canvas.drawShadow(path, Colors.lightBlue, 3, false);
      canvas.drawPath(path, paint..color = Colors.white);

      textPainter.paint(canvas, textOffset);
    }
  }
}
