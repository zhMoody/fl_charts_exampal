part of '../../../line_chart.dart';

/// 绘制曲线
class FixedLineCanvasImpl extends BaseCanvas<Model> {
  @override
  void draw({
    required List<Model> data,
    required Canvas canvas,
    required BaseChartCanvas chartCanvas,
    required BaseLayoutConfig<Model> config,
  }) {
    config as FixedLayout;

    if (config.delegate == null) return;
    final delegate = config.delegate!;
    final bounds = config.bounds;
    final gestureDelegate = config.gestureDelegate;

    final points = <Offset>[];

    var itemWidth = delegate.domainPointSpacing;
    var lineSize = config.delegate?.lineStyle?.strokeWidth ?? 0;
    var maxValue = config.maxValue;
    var maxHeight = bounds.height;

    /// 1s时长对应的宽度，全程24小时，两个点之间的跨度为1小时。
    var dw = itemWidth / 3600; // 3600s为1小时

    for (var index = 0; index < data.length; index++) {
      var model = data[index];
      var seconds = model.xAxis.difference(config.startDate).inSeconds;
      var offset = Offset(
        bounds.left + dw * seconds,
        bounds.bottom - (config.yAxisValue(model) / maxValue) * maxHeight,
      );
      points.add(offset);
    }

    /// 绘制曲线
    /// 这里加上[lineSize]，是为了让曲线点能在top和bottom上完全显示出来。
    if (delegate.lineStyle?.isCurved ?? true) {
      chartCanvas.drawCurvedLine(
        canvas: canvas,
        points: points,
        color: delegate.lineStyle?.color,
        translate: gestureDelegate?.offset,
        strokeWidthPx: delegate.lineStyle?.strokeWidth,
        dashPattern: delegate.lineStyle?.dashPattern,
        gradient: delegate.lineStyle?.gradient,
        roundEndCaps: true,
        clipBounds: math.Rectangle(
          bounds.left - lineSize - (gestureDelegate?.offset.dx ?? 0),
          bounds.top - lineSize,
          bounds.width + lineSize,
          bounds.height + lineSize,
        ),
      );
    } else {
      chartCanvas.drawLine(
        canvas: canvas,
        points: points,
        color: delegate.lineStyle?.color,
        translate: gestureDelegate?.offset,
        strokeWidthPx: delegate.lineStyle?.strokeWidth,
        dashPattern: delegate.lineStyle?.dashPattern,
        roundEndCaps: true,
        clipBounds: math.Rectangle(
          bounds.left - lineSize - (gestureDelegate?.offset.dx ?? 0),
          bounds.top - lineSize,
          bounds.width + lineSize,
          bounds.height + lineSize,
        ),
      );
    }

    /// 绘制气泡
    var style = config.popupSpec?.bubbleSpec;
    if (style == null) return;
    for (var index = 0; index < data.length; ++index) {
      var model = data[index];
      if (model.hasBubble) {
        var model = data[index];
        var seconds = model.xAxis.difference(config.startDate).inSeconds;
        var pointer = Offset(
          bounds.left + dw * seconds,
          bounds.bottom - (config.yAxisValue(model) / maxValue) * maxHeight,
        );
        chartCanvas.drawPoint(
          canvas: canvas,
          offset: pointer,
          radius: style.radius,
          fill: style.fill,
          strokeWidthPx: style.strokeWidthPx,
          stroke: style.stroke,
          translate: gestureDelegate?.offset,
          clipBounds: math.Rectangle(
            bounds.left - (gestureDelegate?.offset.dx ?? 0),
            bounds.top - config.padding.top,
            bounds.width,
            bounds.height + config.padding.bottom,
          ),
        );
      }
    }
  }
}
