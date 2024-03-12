import "package:flutter/material.dart";
import "package:flutter_example/charts/line_chart.dart";
import "package:flutter_example/formmter.dart";

class FullScreenChart extends StatefulWidget {
  const FullScreenChart({
    super.key,
    required this.maxWarning,
    required this.minWarning,
    required this.data,
    required this.constraints,
    this.strokeWidth,
    required this.scaleLength,
  });

  final double? maxWarning;
  final double? minWarning;
  final List<List<(int, double)>> data;
  final double? strokeWidth;
  final BoxConstraints constraints;
  final int scaleLength;

  @override
  State<StatefulWidget> createState() => _FullScreenCartState();
}

class _FullScreenCartState extends State<FullScreenChart> {
  double get max => widget.maxWarning ?? 15;

  double get min => widget.minWarning ?? 4;
  List<Model> convertToModelList(List<List<(int, double)>> originalList) {
    List<Model> result = [];

    for (List<(int, double)> sublist in originalList) {
      for ((int, double) pair in sublist) {
        result.add(
          Model(
            yAxis: pair.$2,
            xAxis: DateTime.fromMillisecondsSinceEpoch(pair.$1 * 1000),
          ),
        );
      }
    }

    return result;
  }

  var timer = 1;

  @override
  Widget build(BuildContext context) {
    var tempData = convertToModelList(widget.data);
    InlineSpan textFormatter(Model data) {
      return TextSpan(
        text: "${data.yAxis.toStringAsFixed(1)} ${data.xAxis.format([
              mm,
              dd,
              " ",
              HH,
              ":",
              nn,
              ":",
              ss,
            ])}",
        style: const TextStyle(
          fontSize: 28,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        children: const [
          TextSpan(
            text: " mmol / L",
            style: TextStyle(
              fontSize: 10,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    String yAxisFormatter(data, index) {
      if (data == 0 && index != 0) {
        return "";
      }
      return data.toString();
    }

    var axisDelegate = AxisDelegate<Model>(
      domainPointSpacing: 245.0 / timer,
      showXAxisLine: true,
      showYAxisLine: true,
      showVerticalHintAxisLine: true,
      showHorizontalHintAxisLine: true,
      labelStyle: const LabelStyle(
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
      axisLineStyle: const LineStyle(color: Colors.grey),
      hintLineStyle: const LineStyle(color: Colors.grey),
      lineStyle: const LineStyle(
        isCurved: true,
        strokeWidth: 2,
        gradient: LinearGradient(
          colors: [Color(0xFF6EA3F9), Colors.pink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );

    return ListView(
      children: [
        ChartGestureView(
          config: FixedLayout(
            data: tempData,
            size: Size(
              widget.constraints.maxWidth - 60,
              widget.constraints.maxHeight - 83,
            ),
            delegate: axisDelegate.copyWith(
              yAxisFormatter: yAxisFormatter,
              minSelectWidth: 4,
              maxWarning: widget.maxWarning,
              minWarning: widget.minWarning,
            ),
            popupSpec: commonPopupSpec.copyWith(
              textFormatter: textFormatter,
            ),
          ),
          builder: (context, config) {
            return CustomPaint(
              size: Size(
                widget.constraints.maxWidth,
                widget.constraints.maxHeight,
              ),
              painter: LineChart(
                data: tempData,
                contentCanvas: FixedLineCanvasImpl(),
                layout: config,
              ),
            );
          },
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  timer = 1;
                });
              },
              child: const Text("3小时"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  timer = 2;
                });
              },
              child: const Text("6小时"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  timer = 4;
                });
              },
              child: const Text("12小时"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  timer = 8;
                });
              },
              child: const Text("24小时"),
            ),
          ],
        ),
      ],
    );
  }
}

const commonPopupSpec = PopupSpec<Model>(
  lineStyle: LineStyle(
    color: Colors.cyan,
    strokeWidth: 2,
  ),
  radius: 8,
  fill: Colors.white,
  stroke: Color(0x29000000),
  strokeWidthPx: 2,
  bubbleSpec: BubbleSpec(
    radius: 8,
    fill: Colors.white,
    strokeWidthPx: 2,
    stroke: Colors.pink,
  ),
);
