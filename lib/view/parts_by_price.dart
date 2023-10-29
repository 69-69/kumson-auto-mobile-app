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
import '../models/vendor.dart';
import '../service/api_service.dart';
import '../service/change_notifier_service.dart';
import '../widgets/async_progress_dialog.dart';
import '../widgets/column_builder.dart';
import '../widgets/show_confirmation_dialog.dart';
import '../widgets/widgetery.dart';

class PartsByPrice extends StatefulWidget {
  final PartModel cPart;
  final VehicleModel vehicle;

  const PartsByPrice({super.key, required this.cPart, required this.vehicle});

  @override
  State<PartsByPrice> createState() => _PartsByPriceState();
}

class _PartsByPriceState extends State<PartsByPrice>
    with SingleTickerProviderStateMixin {
  // Animation setups
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];
  late Future<List<HunterModel>> getPartsHunter;
  String productAge = "";

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

    ChangeNotifierService.getProductAge().then((v) => productAge = v);

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
      body: buildBody(context),
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
          title: buildAppBarTitle(),
          collapseMode: CollapseMode.pin,
        ),
        preferredSize: buildPreferredSize(
            "Available ${widget.cPart.part}".capitalizeEach()),
      );

  /// AppBar Title [buildAppBarTitle]
  Container buildAppBarTitle() {
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
        child: buildRichText(
          "${widget.vehicle.year} ${vPart.make} ${vPart.model}",
          vPart.part,
        ),
      ),
    );
  }

  /// AppBar BG-Image [buildAppBarImage]
  Container buildAppBarImage() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      // Lets create a list of all car image colors
      child: buildAnimatedSwitcher(
          Image.asset("assets/part-p.png"), animationItems),
    );
  }

  /// Parts Details [buildPartsDetails]
  FadeSlide buildBody(BuildContext context) {
    return buildFadeSlide(
      animationItems,
      child: buildCurveContainer(
        context,
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: buildHunterFutureBuilder(widget.cPart.hunter),
      ),
    );
  }

  /// Get Parts from Hunter's [buildHunterFutureBuilder]
  FutureBuilder buildHunterFutureBuilder(String hunterNo) {
    return FutureBuilder(
      future: getPartsHunter,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // By default, show a loading spinner.
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  showCircularProgress(strokeWidth: 3, width: 20, height: 20),
            );
          default:
            if (snapshot.hasError) {
              return const Text('Refresh App');
            } else {
              return snapshot.hasData && snapshot.data.length > 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customLine(
                                widget.cPart.part.toUpperCase(), context),
                            buildOptionalButton(
                                context,
                                onPress: () => displayDialog(context),),
                          ],
                        ),
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

  /// done-1 List view display[buildListView]
  buildListView(result) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      child: ColumnBuilder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          HunterModel huntPart = result[index];
          bool isLastIndex = index == result.length - 1;

          return GestureDetector(
            onTap: () => animateTransition(context,
                PartDetailsCheckout(huntPart: huntPart, vehicle: widget.vehicle)),
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
  Card buildListCard(BuildContext context, HunterModel huntPart, bool isLastIndex) {
    return buildCard(
      shape: isLastIndex
          ? const ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
            )
          : null,
      child: buildVendorFutureBuilder(huntPart),
    );
  }

  /// Get Prices From Vendors [buildVendorFutureBuilder]
  FutureBuilder<List<VendorModel>> buildVendorFutureBuilder(HunterModel h) {
    return FutureBuilder<List<VendorModel>>(
      future: APIService().getVendorParts(h.brand, h.partNo),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // By default, show a loading spinner.
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  showCircularProgress(strokeWidth: 3, width: 20, height: 20),
            );
          default:
            if (snapshot.hasError) {
              return const Text('Refresh App');
            } else {
              return snapshot.data.length > 0
                  ? buildPriceWrapper(context, snapshot.data)
                  : const SizedBox.shrink();
            }
        }
      },
    );
  }

  Column buildPriceWrapper(BuildContext context, List<VendorModel> result) {

    /// Filtering for Min-Price without OPM
    VendorModel minPriceWithoutOPM =
        result.reduce((VendorModel curr, VendorModel next) {
      return (curr.stockStatus == "instock" && next.stockStatus == "instock") &&
              (curr.opm == "no" && curr.opm == "no") &&
              curr.currentPrice < next.currentPrice
          ? curr
          : next;
    });

    /// Filtering for Min-Price with OPM
    VendorModel minPriceWithOPM = result.first;
    for (var e in result) {
      if (e.stockStatus == "instock" &&
          e.opm == "yes" &&
          e.currentPrice < minPriceWithOPM.currentPrice) {
        minPriceWithOPM = e;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (minPriceWithoutOPM.opm == "no" &&
            minPriceWithoutOPM.productAge == productAge) ...{
          buildBadge(context, minPriceWithoutOPM),
          Row(
            children: [
              buildContainerImage(child: Image.asset("assets/part-p.png")),
              buildProductInfo(minPriceWithoutOPM.partNo.toUpperCase(), "$ghCediSign ${minPriceWithoutOPM.currentPrice}"),
            ],
          ),
        },
        if (minPriceWithOPM.stockStatus == "instock" &&
            minPriceWithOPM.opm == "yes" &&
            minPriceWithOPM.productAge == productAge) ...{
          const Divider(height: 1.0),
          buildBadge(context, minPriceWithOPM, isRadius: false),
          Row(
            children: [
              buildContainerImage(child: Image.asset("assets/part-p.png")),
              buildProductInfo(minPriceWithOPM.partNo.toUpperCase(), "$ghCediSign ${minPriceWithOPM.currentPrice}"),
            ],
          ),
        }
      ],
    );
  }

  Row buildBadge(BuildContext context, VendorModel vendor,
      {bool isRadius = true}) {
    String opmCheck(String opm) => opm == "yes" ? "OPEN MARKET " : "";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildBadgeBg(
          child: buildBadgeLabel(
              "${vendor.brand} ${opmCheck(vendor.opm)}${vendor.brandType}",
              color: Theme.of(context).colorScheme.onInverseSurface),
          isRadius: isRadius,
        ),
        buildBadgeBg(
          child: buildBadgeLabel(vendor.productAge),
          isRadius: false,
          radiusRight: true,
        ),
      ],
    );
  }

  Text buildBadgeLabel(String label, {Color? color}) {
    return Text(
      label.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: getProportionateScreenWidth(10),
        fontWeight: FontWeight.bold,
        color: color ?? Colors.white,
      ),
    );
  }

  Container buildBadgeBg(
      {required Text child, bool isRadius = true, bool radiusRight = false}) {
    Radius r = const Radius.circular(8.0);
    ColorScheme theme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: radiusRight ? theme.primary : theme.onSurfaceVariant,
        borderRadius: isRadius
            ? BorderRadius.only(topLeft: r)
            : BorderRadius.only(topRight: radiusRight ? r : Radius.zero),
      ),
      child: child,
    );
  }

  displayDialog(BuildContext context) async {
    final opt = await showConfirmationDialog(
      context,
      title: "Searching",
      isDismissible: false,
      positiveResponse: "New",
      negativeResponse: "Used",
      const Text("...for New or Used Car Parts?"),
    );
    if (context.mounted && opt != "cancel") {
      await ChangeNotifierService.setProductAge(opt);

      // Refresh Screen after Dialog Changes
      Future.delayed(
        const Duration(seconds: 1),
        () => animateTransition(context,
            PartsByPrice(cPart: widget.cPart, vehicle: widget.vehicle)),
      );

      /* refresh page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PartsByPrice(cPart: widget.cPart, vehicle: widget.vehicle)),
            (Route<dynamic> route) => false,
      );*/
    }
  }
}
