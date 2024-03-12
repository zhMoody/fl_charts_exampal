part of '../../line_chart.dart';

/// 构建带有触摸手势的Widget
typedef GestureWidgetBuilder<T> = Widget Function(
  BuildContext context,
  BaseLayoutConfig<T> config,
);

/// 对[BaseChart]的上层封装，加了一层触摸手势检测
/// 传入初始配置信息：[BaseLayoutConfig]
/// 后续触摸手势更新时，构建新的[BaseLayoutConfig]
class ChartGestureView<T> extends StatefulWidget {
  /// Charts配置信息
  final BaseLayoutConfig<T> config;

  /// [BaseChart]
  final GestureWidgetBuilder<T> builder;

  const ChartGestureView({
    super.key,
    required this.config,
    required this.builder,
  });

  @override
  State<ChartGestureView> createState() => _ChartGestureViewState<T>();
}

class _ChartGestureViewState<T> extends State<ChartGestureView<T>> {
  /// 触摸事件
  late GestureDelegate _gestureDelegate;

  Offset? get originalOffset => widget.config.originOffset;

  Offset? get endOffset => widget.config.endOffset;

  double? get draggableWidth => widget.config.draggableWidth;

  Offset? get initializeOffset => widget.config.getInitializeOffset();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _gestureDelegate = widget.config.gestureDelegate ??
        GestureDelegate().copyWith(
          originOffset: originalOffset,
          endOffset: endOffset,
          initializeOffset: initializeOffset,
          width: draggableWidth,
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// Chart
      child: widget.builder(
        context,
        widget.config.copyWith(gestureDelegate: _gestureDelegate),
      ),

      /// 点击事件：点击时可以进行悬浮框的隐藏。
      onTapDown: (details) {
        setState(() {
          _gestureDelegate = _gestureDelegate.copyWith(
            type: GestureType.onTapDown,
            position: GesturePosition(
              local: details.localPosition,
              global: details.globalPosition,
            ),
          );
        });
      },

      /// 拖拽事件：
      /// 这里不能用[onHorizontalDragStart]来开始，会有莫名其妙的问题。
      // onHorizontalDragDown: (detail) {
      //   setState(() {
      //     _gestureDelegate = _gestureDelegate.copyWith(
      //       originOffset: originalOffset,
      //       endOffset: endOffset,
      //       initializeOffset: initializeOffset,
      //       width: draggableWidth,
      //       type: GestureType.onDragStart,
      //       position: GesturePosition(
      //         local: detail.localPosition,
      //         global: detail.globalPosition,
      //       ),
      //     )..initOffset(detail.localPosition);
      //   });
      // },
      // onHorizontalDragUpdate: (detail) {
      //   setState(() {
      //     _gestureDelegate = _gestureDelegate.copyWith(
      //       originOffset: originalOffset,
      //       endOffset: endOffset,
      //       initializeOffset: initializeOffset,
      //       width: draggableWidth,
      //       type: GestureType.onDragUpdate,
      //       position: GesturePosition(
      //         local: detail.localPosition,
      //         global: detail.globalPosition,
      //       ),
      //     )..addOffset(detail.localPosition);
      //   });
      // },
      onHorizontalDragEnd: (detail) {
        setState(() {
          _gestureDelegate = _gestureDelegate.copyWith(
            originOffset: originalOffset,
            endOffset: endOffset,
            initializeOffset: initializeOffset,
            width: draggableWidth,
            type: GestureType.onDragEnd,
          );
        });
      },

      /// 长按事件：
      onLongPressStart: (detail) {
        setState(() {
          _gestureDelegate = _gestureDelegate.copyWith(
            type: GestureType.onLongPressStart,
            position: GesturePosition(
              local: detail.localPosition,
              global: detail.globalPosition,
            ),
          );
        });
      },
      onLongPressMoveUpdate: (detail) {
        setState(() {
          _gestureDelegate = _gestureDelegate.copyWith(
            type: GestureType.onLongPressMoveUpdate,
            position: GesturePosition(
              local: detail.localPosition,
              global: detail.globalPosition,
            ),
          );
        });
      },
      onLongPressEnd: (detail) {
        setState(() {
          _gestureDelegate = _gestureDelegate.copyWith(
            type: GestureType.onLongPressEnd,
            position: GesturePosition(
              local: detail.localPosition,
              global: detail.globalPosition,
            ),
          );
        });
      },
    );
  }
}
