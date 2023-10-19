import 'package:automasters/models/animation_item.dart';
import 'package:automasters/view/vehicle_details.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';

import '../models/parts.dart';
import '../models/vehicle.dart';
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

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: result.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        PartModel huntPart = result[index];
        bool isLastIndex = index == result.length - 1;

        return GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: buildCard(huntPart, isLastIndex),
          ),
        );
      },
    );
  }

  /// Card [buildCard]
  Card buildCard(PartModel cPart, bool isLastIndex) {
    return Card(
      elevation: 3.0,
      // color: const Color(0xFFF0EEF6), //Colors.grey.shade300,
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
              buildContainerImage(),
              buildProductInfo(cPart),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox buildContainerImage() {
    return SizedBox(
      width: getProportionateScreenWidth(88),
      child: AspectRatio(
        aspectRatio: 0.88,
        child: Container(
          padding: EdgeInsets.all(getProportionateScreenWidth(5)),
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                offset: Offset(4, 7),
                color: Colors.white54,
              )
            ],
          ),
          child: Image.asset("assets/part-p.png"),
        ),
      ),
    );
  }

  buildProductInfo(PartModel product) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.part.capitalizeEach(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(2)),
          Text(
            product.model.capitalize(),
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: getProportionateScreenWidth(13),
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
