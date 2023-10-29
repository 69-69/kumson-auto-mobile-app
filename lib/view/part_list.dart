import 'package:automasters/models/animation_item.dart';
import 'package:automasters/view/vehicle_details.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';

import '../models/parts.dart';
import '../models/vehicle.dart';
import '../widgets/column_builder.dart';
import '../widgets/widgetery.dart';
import '../utils/size_config.dart';

class PartList extends StatefulWidget {
  final List<PartModel> carParts;
  final VehicleModel vehicle;

  const PartList({super.key, required this.carParts, required this.vehicle});

  @override
  State<PartList> createState() => _PartListState();
}

class _PartListState extends State<PartList>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Loop through and create animations

    for (int i = 0; i < 10; i++) {
      animationItems.add(
        AnimationItem(
          id: "slide-${i + 1}",
          entry: 30 * (i + 1),
          entryDuration: 250,
          visible: false,
        ),
      );
    }
    animation = Tween<double>(begin: 0, end: 300).animate(animationController)
      ..addListener(() {
        setState(() {
          animationItems = updateVisibleState(animationItems, animation.value);
        });
      });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: buildNestedScrollView(context),
    );
  }

  NestedScrollView buildNestedScrollView(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        buildSliverAppBars(
            context,
            getProportionateScreenHeight(80),
            buildBackButton(context, route: VehicleDetails(vehicle: widget.vehicle)),
            const FlexibleSpaceBar(
              centerTitle: true,
              title: Text("Available Parts"),
              collapseMode: CollapseMode.pin,
            ),
          ),
        ],
      physics: const BouncingScrollPhysics(),
      body: buildPartsDetails(context),
    );
  }

  /// Parts Details [buildPartsDetails]
  FadeSlide buildPartsDetails(BuildContext context) {
    return buildFadeSlide(
      animationItems,
      child: buildCurveContainer(
        context,
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customLine("Choose Your\nCar Part", context),
            const Divider(indent: 40),
            Expanded(
              child: buildListView(),
            ),
          ],
        ),
      ),
    );
  }

  /// List view display[buildListView]
  buildListView() {
    List<PartModel> result = widget.carParts;

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      child: ColumnBuilder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          PartModel huntPart = result[index];
          bool isLastIndex = index == result.length - 1;

          return GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: buildListCard(huntPart, isLastIndex),
            ),
          );
        },
      ),
    );
  }

  /// Card [buildListCard]
  Card buildListCard(PartModel cPart, bool isLastIndex) {
    return buildCard(
      shape: isLastIndex
          ? const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              buildContainerImage(child: Image.asset("assets/part-p.png")),
              buildProductInfo(cPart.part.capitalizeEach(), cPart.model.capitalize(),),
            ],
          ),
        ],
      ),
    );
  }
}
