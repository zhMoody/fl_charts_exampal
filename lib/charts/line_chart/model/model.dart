part of '../../line_chart.dart';

class Model implements Comparable<Model> {
  final double yAxis;
  final DateTime xAxis;
  final bool hasBubble;

  const Model({
    required this.yAxis,
    required this.xAxis,
    this.hasBubble = false,
  });

  @override
  int compareTo(Model other) => xAxis.compareTo(other.xAxis);

  @override
  String toString() {
    return "{ xAxis: $xAxis, yAxis: $yAxis, hasBubble: $hasBubble }";
  }
}
