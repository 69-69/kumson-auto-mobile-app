import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final double? initialChildSize, maxChildSize;
  final Widget child;
  final Function()? onPress;
  final EdgeInsets? padding;

  const CustomBottomSheet({
    required this.child,
    this.onPress,
    this.padding,
    this.initialChildSize,
    this.maxChildSize,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context);

    Widget makeDismissible({required Widget child}) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPress ?? () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
    }

    Container buildContainer(ScrollController controller) {
      return Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // color: const Color.fromRGBO(0, 0, 0, 0.001),
          color: customTheme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.remove, color: customTheme.colorScheme.background),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                child: child,
              ),
            ),
          ],
        ),
      );
    }

    Widget buildSheet() {
      final initialCSize = initialChildSize ?? 0.33;
      final maxCSize = maxChildSize ?? 0.8;

      return makeDismissible(
        child: DraggableScrollableSheet(
          initialChildSize: initialCSize,
          minChildSize: 0.2,
          maxChildSize: maxCSize,
          builder: (_, controller) => buildContainer(controller),
        ),
      );
    }

    return buildSheet();
  }
}
