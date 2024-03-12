import "package:flutter/material.dart";

import "base_painter.dart";

typedef GestureWidgetBuilder<T> = Widget? Function(
  BuildContext context,
  Positions? delegate,
);

class GestureWrapper<T> extends StatefulWidget {
  const GestureWrapper({super.key, required this.builder});

  final GestureWidgetBuilder<T> builder;

  @override
  State<StatefulWidget> createState() => _GestureWrapperState();
}

class _GestureWrapperState<T> extends State<GestureWrapper<T>> {
  final ValueNotifier<Positions?> _positions = ValueNotifier(null);

  set positions(Positions? newValue) {
    if (newValue == positions) {
      return;
    }
    _positions.value = newValue;
  }

  Positions? get positions => _positions.value;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _positions,
      builder: (c, v, _) => GestureDetector(
        onTapDown: (details) {
          positions = Positions(details.localPosition, details.globalPosition);
        },
        onLongPressMoveUpdate: (details) {
          positions = Positions(details.localPosition, details.globalPosition);
        },
        child: widget.builder(context, v),
      ),
    );
  }
}
