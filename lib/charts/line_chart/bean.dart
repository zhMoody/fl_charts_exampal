part of '../line_chart.dart';

class Bean {
  String x;
  double y;
  int? millisSeconds;
  Color? color;

  Bean({
    required this.x,
    required this.y,
    this.millisSeconds,
    this.color,
  });
}
