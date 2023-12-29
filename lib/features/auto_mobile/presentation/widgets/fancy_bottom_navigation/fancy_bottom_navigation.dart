import 'package:flutter/material.dart';
import 'internal/tab_item.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/fancy_bottom_navigation/paint/half_clipper.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/fancy_bottom_navigation/paint/half_painter.dart';

const double circleSize = 40; //60
const double arcHeight = 50; //70
const double arcWidth = 50; //90
const double circleOutline = 10;
const double shadowOutline = 20;
const double barHeight = 60; //80

class FancyBottomNavigation extends StatefulWidget {
  const FancyBottomNavigation({
    super.key,
    // this.key,
    this.textColor,
    this.circleColor,
    required this.tabs,
    this.activeIconColor,
    this.inactiveIconColor,
    this.barBackgroundColor,
    this.initialSelection = 0,
    required this.onTabChangedListener,
  })  : assert(tabs.length > 1 && tabs.length < 6);

  final Function(int position) onTabChangedListener;
  final Color? circleColor,
      activeIconColor,
      inactiveIconColor,
      textColor,
      barBackgroundColor;
  final List<TabData> tabs;
  final int initialSelection;

  // final Key? key;

  @override
  FancyBottomNavigationState createState() => FancyBottomNavigationState();
}

class FancyBottomNavigationState extends State<FancyBottomNavigation>
    with TickerProviderStateMixin, RouteAware {
  /*IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;*/
  dynamic nextIcon = Icons.search;
  dynamic activeIcon = Icons.search;

  int currentSelected = 0;
  double _circleAlignX = 0;
  double _circleIconAlpha = 1;

  late Color circleColor;
  late Color activeIconColor;
  late Color inactiveIconColor;
  late Color barBackgroundColor;
  late Color textColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final customTheme = Theme.of(context);

    activeIcon = widget.tabs[currentSelected].iconData;

    circleColor = widget.circleColor ??
        ((customTheme.brightness == Brightness.dark)
            ? Colors.white
            : customTheme.primaryColor);

    activeIconColor = widget.activeIconColor ??
        ((customTheme.brightness == Brightness.dark)
            ? Colors.black54
            : Colors.white);

    barBackgroundColor = widget.barBackgroundColor ??
        ((customTheme.brightness == Brightness.dark)
            ? const Color(0xFF212121)
            : Colors.white);
    textColor = widget.textColor ??
        ((customTheme.brightness == Brightness.dark)
            ? Colors.white
            : Colors.black54);
    inactiveIconColor = (widget.inactiveIconColor) ??
        ((customTheme.brightness == Brightness.dark)
            ? Colors.white
            : customTheme.primaryColor);
  }

  @override
  void initState() {
    super.initState();
    _setSelected(widget.tabs[widget.initialSelection].key);
  }

  _setSelected(UniqueKey key) {
    int selected = widget.tabs.indexWhere((tabData) => tabData.key == key);

    if (mounted) {
      setState(() {
        currentSelected = selected;
        _circleAlignX = -1 + (2 / (widget.tabs.length - 1) * selected);
        nextIcon = widget.tabs[selected].iconData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: barHeight,
          padding: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
              color: barBackgroundColor,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, -1), blurRadius: 8)
              ]),
          child: _buildRow(),
        ),
        _buildPositioned()
      ],
    );
  }

  Row _buildRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.tabs
          .map(
            (t) => TabItem(
              badges: t.badges,
              uniqueKey: t.key,
              selected: t.key == widget.tabs[currentSelected].key,
              iconData: t.iconData,
              title: t.title,
              iconColor: inactiveIconColor,
              textColor: textColor,
              callbackFunction: (uniqueKey) {
                int selected = widget.tabs
                    .indexWhere((tabData) => tabData.key == uniqueKey);
                widget.onTabChangedListener(selected);
                _setSelected(uniqueKey);
                _initAnimationAndStart(_circleAlignX, 1);
              },
            ),
          )
          .toList(),
    );
  }

  Positioned _buildPositioned() {
    return Positioned.fill(
      top: -(circleSize + circleOutline + shadowOutline) / 2,
      child: AnimatedAlign(
        duration: const Duration(milliseconds: animDuration),
        curve: Curves.easeOut,
        alignment: Alignment(_circleAlignX, 1),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: FractionallySizedBox(
            widthFactor: 1 / widget.tabs.length,
            child: GestureDetector(
              onTap: widget.tabs[currentSelected].onclick as void Function()?,
              child: _buildStack(),
            ),
          ),
        ),
      ),
    );
  }

  Stack _buildStack() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox(
          height: circleSize + circleOutline + shadowOutline,
          width: circleSize + circleOutline + shadowOutline,
          child: ClipRect(
              clipper: HalfClipper(),
              child: Center(
                child: Container(
                  width: circleSize + circleOutline,
                  height: circleSize + circleOutline,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 8)
                    ],
                  ),
                ),
              )),
        ),
        SizedBox(
            height: arcHeight,
            width: arcWidth,
            child: CustomPaint(
              painter: HalfPainter(barBackgroundColor),
            )),
        SizedBox(
          height: circleSize,
          width: circleSize,
          child: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: circleColor),
            child: Padding(
              padding: EdgeInsets.zero,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: animDuration ~/ 5),
                opacity: _circleIconAlpha,
                child: activeIcon is IconData
                    ? Icon(activeIcon, color: activeIconColor)
                    : Image.asset(activeIcon),
                    //: ImageIcon(AssetImage(activeIcon), color: activeIconColor),
              ),
            ),
          ),
        )
      ],
    );
  }

  _initAnimationAndStart(double from, double to) {
    _circleIconAlpha = 0;

    Future.delayed(const Duration(milliseconds: animDuration ~/ 5), () {
      setState(() {
        activeIcon = nextIcon;
      });
    }).then((_) {
      Future.delayed(const Duration(milliseconds: (animDuration ~/ 5 * 3)), () {
        setState(() {
          _circleIconAlpha = 1;
        });
      });
    });
  }

  void setPage(int page) {
    widget.onTabChangedListener(page);
    _setSelected(widget.tabs[page].key);
    _initAnimationAndStart(_circleAlignX, 1);

    setState(() {
      currentSelected = page;
    });
  }
}

class TabData {
  TabData({
    required this.iconData,
    required this.title,
    this.badges = 0,
    this.onclick,
  });

  // IconData iconData;
  dynamic iconData;
  String title;
  int badges;
  Function? onclick;
  final UniqueKey key = UniqueKey();
}
