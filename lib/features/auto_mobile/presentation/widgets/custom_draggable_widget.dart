import 'package:automasters/features/auto_mobile/presentation/pages/home/index.dart';
import 'package:flutter/material.dart';

// ref: https://medium.flutterdevs.com/draggable-floating-action-button-in-flutter-2149a7e47f06

class CustomDraggableWidget extends StatefulWidget {
  final Widget child;
  final Offset initialOffset;
  final VoidCallback? onPress;
  final GlobalKey parentKey;

  const CustomDraggableWidget({
    super.key,
    required this.child,
    required this.initialOffset,
    required this.parentKey,
    this.onPress,
  });

  @override
  State<StatefulWidget> createState() => _CustomDraggableWidgetState();
}

class _CustomDraggableWidgetState
    extends State<CustomDraggableWidget> {
  final GlobalKey _key = GlobalKey();

  bool _isDragging = false;
  Offset? _offset, _minOffset, _maxOffset;

  @override
  void initState() {
    super.initState();
    _offset = widget.initialOffset;

    WidgetsBinding.instance.addPostFrameCallback(_setBoundary);
  }

  @override
  void didChangeDependencies() {
    _offset = widget.initialOffset;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(CustomDraggableWidget oldWidget) {
    if (oldWidget.initialOffset != _offset) {
      WidgetsBinding.instance.addPostFrameCallback(_setBoundary);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _setBoundary(_) {
    final RenderBox parentRenderBox =
    widget.parentKey.currentContext?.findRenderObject() as RenderBox,
        renderBox = _key.currentContext?.findRenderObject() as RenderBox;

    try {
      final Size parentSize = parentRenderBox.size;
      final Size size = renderBox.size;

      setState(() {
        _minOffset = const Offset(0, 0);
        _maxOffset = Offset(
            parentSize.width - size.width, parentSize.height - size.height);
      });
    } catch (e) {
      // print('catch: $e');
    }
  }

  void _updatePosition(PointerMoveEvent pointerMoveEvent) {
    double newOffsetX = getProportionateScreenWidth(_offset!.dx + pointerMoveEvent.delta.dx);
    double newOffsetY = getProportionateScreenHeight(_offset!.dy + pointerMoveEvent.delta.dy);

    double minOffsetX = getProportionateScreenWidth(_minOffset!.dx);
    double maxOffsetX = getProportionateScreenHeight(_maxOffset!.dx);

    if (newOffsetX < minOffsetX) {
      newOffsetX = minOffsetX;
    } else if (newOffsetX > maxOffsetX) {
      newOffsetX = maxOffsetX;
    }

    double minOffsetY = getProportionateScreenWidth(_minOffset!.dy);
    double maxOffsetY = getProportionateScreenHeight(_maxOffset!.dy);

    if (newOffsetY < minOffsetY) {
      newOffsetY = minOffsetY;
    } else if (newOffsetY > maxOffsetY) {
      newOffsetY = maxOffsetY;
    }

    setState(() => _offset = Offset(newOffsetX, newOffsetY));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return AnimatedPositioned(
      left: getProportionateScreenWidth(_offset!.dx),
      top: getProportionateScreenHeight(_offset!.dy),
      duration: const Duration(milliseconds: 250),
      child: Listener(
        onPointerMove: (PointerMoveEvent pointerMoveEvent) {
          _updatePosition(pointerMoveEvent);

          setState(() => _isDragging = true);
        },
        onPointerUp: (PointerUpEvent pointerUpEvent) {
          setState(() => _isDragging ? _isDragging = false : widget.onPress);
        },
        child: Container(key: _key, child: widget.child),
      ),
    );
  }
}