part of '../../line_chart.dart';

/// Base 绘制内容
abstract class BaseCanvas<T> {
  const BaseCanvas();

  void draw({
    required List<T> data,
    required Canvas canvas,
    required BaseChartCanvas chartCanvas,
    required BaseLayoutConfig<T> config,
  });
}
