import 'package:automasters/models/animation_item.dart';
import 'package:automasters/models/parts.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/view/part_details_checkout.dart';
import 'package:automasters/utils/animation_transition.dart';
import 'package:automasters/view/vehicle_details.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';

import '../models/hunter.dart';
import '../models/vehicle.dart';
import '../service/api_service.dart';
import '../widgets/column_builder.dart';
import '../widgets/widgetery.dart';

class PartsCrossRef extends StatefulWidget {
  final PartModel cPart;
  final VehicleModel vehicle;

  const PartsCrossRef({super.key, required this.cPart, required this.vehicle});

  @override
  State<PartsCrossRef> createState() => _PartsCrossRefState();
}

class _PartsCrossRefState extends State<PartsCrossRef>
    with SingleTickerProviderStateMixin {
  // Animation setups
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];

  late Future<List<HunterModel>> getPartsHunter;

  @override
  void initState() {
    getPartsHunter =
        APIService().getHunterPartsBy(hunterNo: widget.cPart.hunter);

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
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: buildNestedScrollView(context),
    );
  }

  NestedScrollView buildNestedScrollView(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [buildSliverAppBar(context)],
      physics: const BouncingScrollPhysics(),
      body: buildPartsDetails(context),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) => buildSliverAppBars(
        context,
        getProportionateScreenHeight(250),
        buildBackButton(context,
            route: VehicleDetails(vehicle: widget.vehicle)),
        FlexibleSpaceBar(
          background: buildAppBarImage(),
          centerTitle: true,
          title: buildPartName(),
          collapseMode: CollapseMode.pin,
        ),
        preferredSize: buildPreferredSize("Available ${widget.cPart.part}"),
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
      child: buildFadeSlide(
        animationItems,
        child: buildRichText("${vPart.part} for",
            "${widget.vehicle.year} ${vPart.make} ${vPart.model}"),
      ),
    );
  }

  /// Vehicle Image [buildAppBarImage]
  Container buildAppBarImage() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      // Lets create a list of all car image colors
      child: buildAnimatedSwitcher(
          Image.asset("assets/part-p.png"), animationItems),
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
    return buildFadeSlide(
      animationItems,
      child: buildCurveContainer(
        context,
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: buildFutureBuilder(),
      ),
    );
  }

  FutureBuilder<List<HunterModel>> buildFutureBuilder() {
    return FutureBuilder<List<HunterModel>>(
      future: getPartsHunter,
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
                        const Divider(indent: 40),
                        Expanded(
                          child: buildListView(snapshot.data),
                        ),
                      ],
                    )
                  : buildMakeARequestButton(context);
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
        customLine(widget.cPart.part.toUpperCase(), context),
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
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: ColumnBuilder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          HunterModel huntPart = result[index];
          bool isLastIndex = index == result.length - 1;

          return GestureDetector(
            onTap: () => animateTransition(
                context,
                PartDetailsCheckout(
                    huntPart: huntPart, vehicle: widget.vehicle)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: buildListCard(context, huntPart, isLastIndex),
            ),
          );
        },
      ),
    );
  }

  /// Card [buildListCard]
  Card buildListCard(
      BuildContext context, HunterModel huntPart, bool isLastIndex) {
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildContainerImage(child: Image.asset("assets/part-p.png")),
          buildProductInfo(
              huntPart.brand.capitalizeEach(), huntPart.partNo.capitalize()),
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
               Icon(Icons.adaptive.arrow_forward, size: 16),
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
