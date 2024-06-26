import 'package:flutter/material.dart';

class ScrollChecker extends StatefulWidget {
  const ScrollChecker({
    super.key,
    required this.controller,
    required this.builder,
  });

  final ScrollController controller;
  final Widget Function(bool isScrollable) builder;

  @override
  State<ScrollChecker> createState() => _ScrollCheckerState();
}

class _ScrollCheckerState extends State<ScrollChecker> {
  late final ScrollController _scrollController;
  late bool _isScrollable;

  @override
  void initState() {
    _scrollController = widget.controller;

    _isScrollable = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isScrollable = _scrollController.position.maxScrollExtent > 0;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(_isScrollable);
  }
}