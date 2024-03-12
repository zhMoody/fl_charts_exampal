part of '../../line_chart.dart';

abstract class BaseChart<T> extends CustomPainter {
  /// 数据源
  final List<T> data;

  /// charts配置信息
  final BaseLayoutConfig<T> layout;

  /// chart基础绘制：点、线、面,一般的绘制用这个足够了，不够的话，可以扩展。
  final BaseChartCanvas chartCanvas;

  /// 坐标系绘制
  final BaseCanvas? axisCanvas;

  /// charts内容绘制
  final BaseCanvas? contentCanvas;

  const BaseChart({
    required this.data,
    required this.layout,
    required this.chartCanvas,
    this.axisCanvas,
    this.contentCanvas,
  });

  @override
  bool shouldRepaint(covariant BaseChart oldDelegate) =>
      oldDelegate.data != data || oldDelegate.layout != layout;

  @override
  void paint(Canvas canvas, Size size) {
    _onDrawAxis(canvas, layout.bounds);
    _onDraw(canvas, layout.bounds);
    if (layout.gestureDelegate != null) {
      onDrawGesture(canvas, layout.bounds);
    }
  }

  /// 绘制坐标系
  void _onDrawAxis(Canvas canvas, Rect bounds) {
    axisCanvas?.draw(
      data: data,
      canvas: canvas,
      config: layout,
      chartCanvas: chartCanvas,
    );
  }

  /// 绘制 Charts
  void _onDraw(Canvas canvas, Rect bounds) {
    contentCanvas?.draw(
      data: data,
      canvas: canvas,
      config: layout,
      chartCanvas: chartCanvas,
    );
  }

  void onDrawGesture(Canvas canvas, Rect bounds) {}
}
