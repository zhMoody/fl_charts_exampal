part of '../../line_chart.dart';

/// Flutter implementation for text measurement and painter.
class TextElement implements BaseTextElement {
  static const ellipsis = "\u{2026}";

  @override
  final InlineSpan text;

  final double? textScaleFactor;

  var _painterReady = false;
  TxtDirection _txtDirection = TxtDirection.ltr;

  @override
  TextAlign textAlign;

  int? _maxWidth;
  MaxWidthStrategy? _maxWidthStrategy;

  late TextPainter _textPainter;

  late TextMeasurement _measurement;

  TextElement(
    this.text, {
    this.textAlign = TextAlign.left,
    this.textScaleFactor,
  });

  @override
  set txtDirection(TxtDirection direction) {
    if (_txtDirection == direction) {
      return;
    }
    _txtDirection = direction;
    _painterReady = false;
  }

  @override
  TxtDirection get txtDirection => _txtDirection;

  @override
  int? get maxWidth => _maxWidth;

  @override
  set maxWidth(int? value) {
    if (_maxWidth == value) {
      return;
    }
    _maxWidth = value;
    _painterReady = false;
  }

  @override
  MaxWidthStrategy? get maxWidthStrategy => _maxWidthStrategy;

  @override
  set maxWidthStrategy(MaxWidthStrategy? maxWidthStrategy) {
    if (_maxWidthStrategy == maxWidthStrategy) {
      return;
    }
    _maxWidthStrategy = maxWidthStrategy;
    _painterReady = false;
  }

  @override
  TextMeasurement get measurement {
    if (!_painterReady) {
      _refreshPainter();
    }

    return _measurement;
  }

  /// The estimated distance between where we asked to draw the text (top, left)
  /// and where it visually started (top + verticalFontShift, left).
  ///
  /// 10% of reported font height seems to be about right.
  int get verticalFontShift {
    if (!_painterReady) {
      _refreshPainter();
    }

    return (_textPainter.height * 0.1).ceil();
  }

  TextPainter? get textPainter {
    if (!_painterReady) {
      _refreshPainter();
    }
    return _textPainter;
  }

  /// Create text painter and measure based on current settings
  void _refreshPainter() {
    _textPainter = TextPainter(text: text)
      ..textDirection = TextDirection.ltr
      ..textAlign = textAlign
      ..ellipsis =
          maxWidthStrategy == MaxWidthStrategy.ellipsize ? ellipsis : null;

    if (textScaleFactor != null) {
      _textPainter.textScaler = TextScaler.linear(textScaleFactor!);
    }

    _textPainter.layout(maxWidth: maxWidth?.toDouble() ?? double.infinity);

    final baseline =
        _textPainter.computeDistanceToActualBaseline(TextBaseline.alphabetic);

    // Estimating the actual draw height to 70% of measures size.
    //
    // The font reports a size larger than the drawn size, which makes it
    // difficult to shift the text around to get it to visually line up
    // vertically with other components.
    _measurement = TextMeasurement(
        horizontalSliceWidth: _textPainter.width,
        verticalSliceWidth: _textPainter.height * 0.7,
        baseline: baseline);

    _painterReady = true;
  }
}
