import 'package:automasters/models/animation_item.dart';
import 'package:automasters/models/parts.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/view/part_details_checkout.dart';
import 'package:automasters/utils/animation_transition.dart';
import 'package:automasters/view/vehicle_details.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:automasters/widgets/scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';

import '../models/hunter.dart';
import '../models/vehicle.dart';
import '../service/apiService.dart';
import '../utils/custom_line.dart';
import '../utils/text_tools.dart';

class PartsCategory extends StatefulWidget {
  final PartModel cPart;
  final VehicleModel vehicle;

  const PartsCategory({super.key, required this.cPart, required this.vehicle});

  @override
  State<PartsCategory> createState() => _PartsCategoryState();
}

class _PartsCategoryState extends State<PartsCategory>
    with SingleTickerProviderStateMixin {
  // Animation setups
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];

  late Future<List<HunterModel>> getProductsHunter;

  @override
  void initState() {
    getProductsHunter = APIService().getProductsByHunter(widget.cPart.hunter);

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
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
          animationItems = updateVisibleState(
            animationItems,
            animation.value,
          );
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: buildNestedScrollView(context),
    );
  }

  NestedScrollView buildNestedScrollView(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) {
        return [
          buildSliverAppBar(context),
        ];
      },
      physics: const BouncingScrollPhysics(),
      body: buildPartsDetails(context),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
          primary: true,
          pinned: true,
          floating: false,
          centerTitle: true,
          expandedHeight: getProportionateScreenHeight(250),
          leadingWidth: 100,
          leading: GestureDetector(
            onTap: () => animateTransition(
                context, VehicleDetails(vehicle: widget.vehicle)),
            child: buildBackButton(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: buildAppBarImage(),
            centerTitle: true,
            title: buildPartName(),
            collapseMode: CollapseMode.pin,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Transform.translate(
              offset: const Offset(0, 50),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text("Available ${widget.cPart.part}".capitalizeEach()),
              ),
            ),
          ),
          /*shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
          ),*/
        );
  }

  buildBackButton() => Container(
    height: getProportionateScreenHeight(40.0),
    width: getProportionateScreenWidth(40.0),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.grey.withOpacity(0.7),
      ),
    ),
    child: const Icon(Icons.chevron_left),
  );

  Container buildPartName() {
    PartModel vPart = widget.cPart;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.3),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
      ),
      child: FadeSlide(
        direction: getItemVisibility("slide-2", animationItems),
        duration: getSlideDuration("slide-2", animationItems),
        offsetY: 60.0,
        offsetX: 0.0,
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: [
              TextSpan(
                text:
                    "${vPart.part.capitalizeEach()} for\n",
                style: const TextStyle(
                  height: 1.7,
                  fontSize: 13.0,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text:  "${widget.vehicle.year} ${vPart.make} ${vPart.model}".capitalizeEach(),
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Vehicle Image [buildAppBarImage]
  Container buildAppBarImage() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      // Lets create a list of all car image colors
      child: AnimatedSwitcher(
        // This switcher doesn't work, flutter can't
        // understand the child change without a key property here
        // I will include a link to a video talking more about keys
        duration: const Duration(milliseconds: 500),
        child: ScaleAnimation(
          key: const ValueKey("assets/part-p.png"),
          duration: getSlideDuration("slide-3", animationItems),
          direction: getItemVisibility("slide-3", animationItems),
          child: Align(
            alignment: Alignment.center,
            child: Image.asset("assets/part-p.png"),
          ),
        ),
      ),
    );
  }

  /// Loader [buildProgressBar]
  Center buildProgressBar() {
    return const Center(
      heightFactor: 1,
      widthFactor: 1,
      child: SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(
          strokeWidth: 5,
        ),
      ),
    );
  }

  /// Parts Details [buildPartsDetails]
  FadeSlide buildPartsDetails(BuildContext context) {
    return FadeSlide(
      duration: getSlideDuration("slide-4", animationItems),
      direction: getItemVisibility("slide-4", animationItems),
      offsetX: 0.0,
      offsetY: 60.0,
      child: Container(
        height: SizeConfig.screenHeight!,
        width: SizeConfig.screenWidth!,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 32.0,
        ),
        child: buildFutureBuilder(),
      ),
    );
  }

  FutureBuilder<List<HunterModel>> buildFutureBuilder() {
    return FutureBuilder<List<HunterModel>>(
      future: getProductsHunter,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // By default, show a loading spinner.
            return buildProgressBar();
          default:
            if (snapshot.hasError) {
              return const Text('Refresh App');
            } else {
              return snapshot.data.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildListViewHeader(context, snapshot),
                        const Divider(thickness: 2, indent: 40),
                        Expanded(
                          child: buildListView(snapshot.data),
                        ),
                      ],
                    )
                  : Center(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            width: 1.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {},
                        child: const Text("Make a Request"),
                      ),
                    );
            }
        }
      },
    );
  }

  /// List View Header[buildListViewHeader]
  Row buildListViewHeader(
      BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customLine(widget.cPart.part.toUpperCase(), true, context),
        /*TextButton(
          onPressed: () {
            animateTransition(
              context,
              PartList(
                carParts: snapshot.data,
                vehicle: widget.vehicle,
              ),
            );
          },
          child: const Text("See All"),
        ),*/
      ],
    );
  }

  /// List view display[buildListView]
  buildListView(result) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: result.length,
      itemBuilder: (context, index) {
        HunterModel huntPart = result[index];
        bool isLastIndex = index == result.length - 1;

        return GestureDetector(
          onTap: () => animateTransition(context,
              PartDetailsCheckout(huntPart: huntPart, vehicle: widget.vehicle)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: buildCard(context, huntPart, isLastIndex),
          ),
        );
      },
    );
  }

  /// Card [buildCard]
  Card buildCard(BuildContext context, HunterModel huntPart, bool isLastIndex) {
    return Card(
      elevation: 3.0,
      color: const Color(0xFFF0EEF6), //Colors.grey.shade300,
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
              buildProductInfo(huntPart),
            ],
          ),
          /*const SizedBox(width: 12),
          const Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.arrow_forward, size: 16),
          ),*/
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
            // color: Colors.grey.shade200,
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

  buildProductInfo(HunterModel product) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.brand.capitalizeEach(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(2)),
          Text(product.partNo.capitalize(),
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

/*

        Container(
          width: double.infinity,
          color: Colors.grey.shade200,
          padding: const EdgeInsets.fromLTRB(1, 3, 10, 3),
          margin: const EdgeInsets.only(top: 5.0),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white70,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  width: getProportionateScreenWidth(80),
                  height: getProportionateScreenHeight(80),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset("assets/part-p.png"),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TextTools.toUppercaseFirstLetterEach(huntPart.brand),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      TextTools.toUppercaseFirstLetterEach(huntPart.partNo),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        overflow: TextOverflow.ellipsis,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
            onTap: () => animateTransition(context,
                PartDetailsCheckout(carParts: result, vehicle: widget.vehicle)),
          ),
        );
ListView buildListView(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return ListView(
                  primary: false,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customLine("Parts Categories", true, context),
                        TextButton(
                          onPressed: () {
                            animateTransition(
                              context,
                              PartList(
                                carParts: snapshot.data,
                                vehicle: widget.vehicle,
                              ),
                            );
                          },
                          child: const Text("See All"),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                      indent: 40,
                    ),
                    buildListViewBody(snapshot.data),
                  ],
                );
  }

  Widget buildListViewBody(result) {
    return result != null && result.length > 0
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: result.map<Widget>((PartModel carPart) {
        return Container(
          width: double.infinity,
          color: Colors.grey.shade200,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 5.0),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  carPart.part.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
            onTap: () => animateTransition(
                context, PartDetails(carParts: result, vehicle: widget.vehicle)),
          ),
        );
      }).toList(),
    )
        : const SizedBox.shrink();
  }*/
