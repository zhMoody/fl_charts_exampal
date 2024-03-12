part of '../../line_chart.dart';

/// 绘制 折线、曲线。
class LineChart<T> extends BaseChart<T> {
  const LineChart({
    required super.data,
    required super.layout,
    super.chartCanvas = const ChartCanvasImpl(),
    super.axisCanvas = const AxisCanvasImpl(),
    super.contentCanvas,
  });

  /// 绘制悬浮框
  @override
  void onDrawGesture(Canvas canvas, Rect bounds) {
    LinePopupCanvas.draw<T>(
      canvas: canvas,
      config: layout,
      chartCanvas: chartCanvas,
    );
  }
}
