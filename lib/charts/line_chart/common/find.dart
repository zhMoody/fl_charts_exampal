part of '../../line_chart.dart';

/// 根据触摸时的坐标查找到最匹配的数据和位置信息。
class ChartTargetFind<T> {
  final T model;
  final Offset offset;

  ChartTargetFind(this.model, this.offset);
}
