part of '../../line_chart.dart';

/// 绘制内容
abstract class BaseChartCanvas {
  const BaseChartCanvas();

  /// 绘制点
  void drawPoint({
    required Canvas canvas,
    required Offset offset,
    required double radius,
    Color? fill,
    Color? stroke,
    double? strokeWidthPx,
    BlendMode? blendMode,
    math.Rectangle<num>? clipBounds,
    Offset? translate,
  });

  /// 绘制线
  void drawLine({
    required Canvas canvas,
    required List<Offset> points,
    math.Rectangle<num>? clipBounds,
    Offset? translate,
    Color? color,
    bool? roundEndCaps,
    double? strokeWidthPx,
    List<int>? dashPattern,
  });

  /// 绘制曲线
  void drawCurvedLine({
    required Canvas canvas,
    required List<Offset> points,
    math.Rectangle<num>? clipBounds,
    Offset? translate,
    Color? color,
    bool? roundEndCaps,
    double? strokeWidthPx,
    List<int>? dashPattern,
    Gradient? gradient,
  });

  /// 绘制矩形
  void drawRect({
    required Canvas canvas,
    required math.Rectangle<num> bounds,
    math.Rectangle<num>? clipBounds,
    Offset? translate,
    Color? fill,
    Color? stroke,
    double? strokeWidthPx,
  });

  /// 绘制圆角矩形
  void drawRRect({
    required Canvas canvas,
    required math.Rectangle<num> bounds,
    math.Rectangle<num>? clipBounds,
    Offset? translate,
    Color? fill,
    Color? stroke,
    double? strokeWidthPx,
    num? radius,
    bool roundTopLeft = false,
    bool roundTopRight = false,
    bool roundBottomLeft = false,
    bool roundBottomRight = false,
  });

  /// 绘制文字
  void drawText({
    required Canvas canvas,
    required BaseTextElement textElement,
    required Offset offset,
    double rotation = 0.0,
    Offset? translate,
  });
}
