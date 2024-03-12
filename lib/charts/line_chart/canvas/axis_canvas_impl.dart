part of '../../line_chart.dart';

/// 绘制坐标系；域轴、辅助线、坐标值，
class AxisCanvasImpl<T> extends BaseCanvas<T> {
  const AxisCanvasImpl() : super();

  @override
  void draw({
    required List<T> data,
    required Canvas canvas,
    required BaseLayoutConfig<T> config,
    required BaseChartCanvas chartCanvas,
  }) {
    /// 绘制域轴
    _AxisCanvas.draw(
      data: data,
      canvas: canvas,
      config: config,
      chartCanvas: chartCanvas,
    );

    /// 绘制坐标值
    _AxisValueCanvas.draw<T>(
      data: data,
      canvas: canvas,
      config: config,
      chartCanvas: chartCanvas,
    );
  }
}

/// 绘制坐标轴、辅助线
class _AxisCanvas {
  static void draw<T>({
    required List<T> data,
    required Canvas canvas,
    required BaseChartCanvas chartCanvas,
    required BaseLayoutConfig<T> config,
  }) {
    if (config.delegate == null) return;

    ///
    final delegate = config.delegate!;
    final gestureDelegate = config.gestureDelegate;
    final bounds = config.bounds;

    /// 绘制横轴辅助线
    if (delegate.showHorizontalHintAxisLine) {
      var height = bounds.height;
      var lineStyle = delegate.hintLineStyle;
      var lineNum = delegate.hintLineNum;

      if (delegate.maxWarning != null && delegate.minWarning != null) {
        final maxValue = config.maxValue;
        final average = height / maxValue;
        final maxWarningH = delegate.maxWarning! * average;
        final minWarningH = delegate.minWarning! * average;
        for (var i = 0; i < lineNum + 1; ++i) {
          Color? tempColor;
          List<int>? dashPattern;
          double h;
          if (i == 1 || i == 2) {
            tempColor = Colors.pink;
            dashPattern = [5];
            h = i == 1 ? minWarningH : maxWarningH;
          } else {
            final tempH = height / lineNum * i;
            final useWarning = (tempH - maxWarningH) < 1;
            h = useWarning ? maxWarningH : tempH;
            tempColor = useWarning ? Colors.pink : lineStyle?.color;
            dashPattern = useWarning ? [5] : lineStyle?.dashPattern;
          }

          chartCanvas.drawLine(
            canvas: canvas,
            color: tempColor,
            strokeWidthPx: lineStyle?.strokeWidth,
            dashPattern: dashPattern,
            points: [
              Offset(bounds.left, bounds.bottom - h),
              Offset(bounds.right, bounds.bottom - h),
            ],
          );
        }
      } else {
        final itemHeight = height ~/ lineNum;
        for (var index = 0; index < lineNum + 1; ++index) {
          chartCanvas.drawLine(
            canvas: canvas,
            color: lineStyle?.color,
            strokeWidthPx: lineStyle?.strokeWidth,
            dashPattern: lineStyle?.dashPattern,
            points: [
              Offset(bounds.left, bounds.bottom - itemHeight * index),
              Offset(bounds.right, bounds.bottom - itemHeight * index),
            ],
          );
        }
      }
    }

    /// 绘制x轴
    if (delegate.showXAxisLine) {
      chartCanvas.drawLine(
        canvas: canvas,
        color: delegate.axisLineStyle?.color,
        strokeWidthPx: delegate.axisLineStyle?.strokeWidth,
        dashPattern: delegate.axisLineStyle?.dashPattern,
        points: [
          Offset(bounds.left, bounds.bottom),
          Offset(bounds.right, bounds.bottom),
        ],
      );
    }

    /// 绘制y轴
    if (delegate.showYAxisLine) {
      chartCanvas.drawLine(
        canvas: canvas,
        color: delegate.axisLineStyle?.color,
        strokeWidthPx: delegate.axisLineStyle?.strokeWidth,
        dashPattern: delegate.axisLineStyle?.dashPattern,
        points: [
          Offset(bounds.left, bounds.bottom),
          Offset(bounds.left, bounds.top),
        ],
      );
    }

    /// 绘制最右侧的y轴
    if (delegate.showEndYAxisLine) {
      chartCanvas.drawLine(
        canvas: canvas,
        color: delegate.axisLineStyle?.color,
        strokeWidthPx: delegate.axisLineStyle?.strokeWidth,
        dashPattern: delegate.axisLineStyle?.dashPattern,
        points: [
          Offset(bounds.right, bounds.bottom),
          Offset(bounds.right, bounds.top),
        ],
      );
    }

    /// 绘制纵轴方向的辅助线
    var itemSpacing = delegate.domainPointSpacing.toInt();
    if (delegate.showVerticalHintAxisLine) {
      canvas
        ..save()
        ..clipRect(
          Rect.fromLTWH(
            bounds.left,
            bounds.top,
            bounds.width,
            bounds.height,
          ),
        );

      for (var index = 0; index < config.xAxisCount; index++) {
        Offset offset = Offset(
          bounds.left + itemSpacing * index,
          bounds.bottom + delegate.labelVerticalSpacing,
        );

        chartCanvas.drawLine(
          canvas: canvas,
          points: [
            Offset(offset.dx, bounds.bottom),
            Offset(offset.dx, bounds.top),
          ],
          dashPattern: [4],
          translate: gestureDelegate?.offset,
        );
      }
      canvas.restore();
    }
  }
}

/// 绘制坐标值
class _AxisValueCanvas {
  static void draw<T>({
    required List<T> data,
    required Canvas canvas,
    required BaseChartCanvas chartCanvas,
    required BaseLayoutConfig<T> config,
  }) {
    if (config.delegate == null) return;

    var delegate = config.delegate!;
    var bounds = config.bounds;
    var gestureDelegate = config.gestureDelegate;
    var labelHorizontalSpacing = delegate.labelHorizontalSpacing;

    /// 绘制横坐标
    /// 当有拖动偏移量时，需要将x轴坐标值区域裁剪。
    canvas
      ..save()
      ..clipRect(
        Rect.fromLTWH(
          bounds.left / 2,
          bounds.bottom,
          bounds.right - config.padding.right / 2,
          bounds.bottom + delegate.labelVerticalSpacing,
        ),
      );

    var itemSpacing = delegate.domainPointSpacing.toInt();

    for (var index = 0; index < config.xAxisCount; index += 3) {
      var element = TextElement(
        TextSpan(
          text: config.xAxisValue(index) ??
              config.delegate?.xAxisFormatter?.call(index),
          style: delegate.labelStyle?.style,
        ),
        textAlign: TextAlign.center,
      );
      // 当前点
      print("$labelHorizontalSpacing , $itemSpacing, $index");
      Offset offset = Offset(
        bounds.left - labelHorizontalSpacing + itemSpacing * index,
        bounds.bottom + delegate.labelVerticalSpacing,
      );
      chartCanvas.drawText(
        canvas: canvas,
        textElement: element,
        offset: offset,
        translate: gestureDelegate?.offset,
      );
    }
    canvas.restore();

    /// 绘制纵坐标
    int num = delegate.hintLineNum;
    var dValue = config.maxValue / num;

    final maxValue = config.maxValue;
    final average = bounds.height / maxValue;
    final maxWarningH = delegate.maxWarning! * average;
    final minWarningH = delegate.minWarning! * average;

    for (var i = 0; i < num + 1; ++i) {
      double h;
      TextStyle? style;
      double? value;
      if (i == 1 || i == 2) {
        value = i == 1 ? delegate.minWarning : delegate.maxWarning;
        h = i == 1 ? minWarningH : maxWarningH;
        style = delegate.labelStyle?.style.copyWith(color: Colors.pink);
      } else {
        h = bounds.height / num * i;
        final useWarning = i != 0 ? (h * i - maxWarningH) < 1 : false;
        style = useWarning
            ? delegate.labelStyle?.style.copyWith(color: Colors.pink)
            : delegate.labelStyle?.style;
        value = dValue * i;
      }

      final element = TextElement(
        TextSpan(
          text: delegate.yAxisFormatter?.call(value ?? 0, i),
          style: style,
        ),
      );
      element.textAlign = TextAlign.end;
      element.txtDirection = TxtDirection.center;
      chartCanvas.drawText(
        canvas: canvas,
        textElement: element,
        offset: Offset(
          bounds.right + labelHorizontalSpacing,
          bounds.bottom - h - (delegate.labelStyle?.style.fontSize ?? 0) / 2,
        ),
      );
    }
  }
}
