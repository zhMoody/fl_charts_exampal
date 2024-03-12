import "package:flutter/material.dart";
import "package:flutter_example/formmter.dart";

class Positions {
  Offset? local;
  Offset? global;
  Positions(this.local, this.global);
}

typedef TextOffsetCallback = Offset Function(Size size);

abstract class BasePainter<T> extends CustomPainter {
  BasePainter({super.repaint, this.positions});
  double get kDesignMarginLeft => 27;

  final Positions? positions;

  double get kScaleH => 34;

  Canvas? get canvas => _canvas;
  Canvas? _canvas;

  double get end => size.width;

  Paint get bottomAxis => Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.lightBlue
    ..strokeWidth = 1;

  Paint get axis => Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.grey
    ..strokeWidth = 1;

  Paint get grid => Paint()
    ..strokeWidth = 0.5
    ..color = Colors.grey
    ..style = PaintingStyle.stroke;

  Paint get dashWarningAxis => Paint()
    ..strokeWidth = 0.5
    ..color = Colors.purple
    ..style = PaintingStyle.stroke;

  Paint get fill => Paint()
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke;

  set canvas(Canvas? canvas) {
    if (canvas != null && _canvas != canvas) {
      _canvas = canvas;
    }
  }

  Size get size => _size;
  Size _size = Size.zero;

  set size(Size sz) {
    if (_size != sz) {
      _size = sz;
    }
  }

  double xAxisScaleTextXBy({required Size textSize}) => -textSize.width / 2;

  final _textPainter = TextPainter(textDirection: TextDirection.ltr);

  void drawText(
    Canvas? canvas,
    String str, {
    double fontSize = 12,
    Color color = Colors.grey,
    FontWeight fontWeight = FontWeight.w500,
    TextOffsetCallback? offset,
  }) {
    final text = TextSpan(
      text: str,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
    _textPainter.text = text;
    _textPainter.layout();

    final textOffset = (offset ??
        (Size size) => Offset(
              -size.width,
              -size.height / 2,
            ))(_textPainter.size);
    if (canvas != null) {
      _textPainter.paint(canvas, textOffset);
    }
  }

  double calculatePercentage(int timestamp) {
    final now = DateTime.now();
    final mid = DateTime(now.year, now.month, now.day);
    final givenTime = timestamp.toSecondsSinceEpoch;
    final diff = givenTime.difference(mid).inSeconds;
    return diff / (24 * 3600);
  }

  @mustCallSuper
  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.size = size;
  }

  void onDrawGesture(Canvas canvas, Size size) {}
}
