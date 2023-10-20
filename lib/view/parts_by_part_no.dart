import 'package:automasters/models/animation_item.dart';
import 'package:automasters/models/parts.dart';
import 'package:automasters/models/vehicle.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/view/part_details_checkout.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:string_capitalize/string_capitalize.dart';

import '../models/hunter.dart';
import '../models/vendor.dart';
import '../service/api_service.dart';
import '../service/change_notifier_service.dart';
import '../utils/animation_transition.dart';
import '../widgets/async_progress_dialog.dart';
import '../widgets/show_confirmation_dialog.dart';
import '../widgets/widgetery.dart';

class PartsByPartNo extends StatefulWidget {
  final List<HunterModel> cPart;

  const PartsByPartNo({super.key, required this.cPart});

  @override
  State<PartsByPartNo> createState() => _PartsByPartNoState();
}

class _PartsByPartNoState extends State<PartsByPartNo>
    with SingleTickerProviderStateMixin {
  // Animation setups
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];
  VehicleModel vehicle = VehicleModel();
  String productAge = "";

  @override
  void initState() {
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
        buildBackButton(context),
        FlexibleSpaceBar(
          background: buildAppBarImage(),
          centerTitle: true,
          title: buildAppBarTitle(),
          collapseMode: CollapseMode.pin,
        ),
        preferredSize: buildPreferredSize(
            "Available ${widget.cPart[0].product}".capitalizeEach()),
      );

  /// AppBar Title [buildAppBarTitle]
  Container buildAppBarTitle() {
    HunterModel vPart = widget.cPart[0];

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
          vPart.product,
          "${vehicle.year} ${vehicle.make} ${vehicle.model}",
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
    List<HunterModel> vPart = widget.cPart;

    return buildFadeSlide(
      animationItems,
      child: buildCurveContainer(
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customLine(vPart[0].brand.toUpperCase(), context),
                buildProductAgeButton(
                    onPress: () => displayDialog(context),
                    color: Theme.of(context).colorScheme.primary),
              ],
            ),
            const Divider(indent: 40),
            Expanded(
              child: buildListView(vPart),
            ),
          ],
        ),
      ),
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
        // bool isLastIndex = index == result.length - 1;

        return GestureDetector(
          onTap: () {
            animateTransition(context,
                PartDetailsCheckout(huntPart: huntPart, vehicle: vehicle));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: buildCard(context, huntPart),
          ),
        );
      },
    );
  }

  /// Card [buildCard]
  Card buildCard(BuildContext context, HunterModel huntPart) {
    return Card(
      elevation: 3.0,
      child: buildFutureBuilder(huntPart),
    );
  }

  /// Get Prices From Vendors [buildFutureBuilder]
  FutureBuilder buildFutureBuilder(HunterModel h) {
    return FutureBuilder(
      future: Future.wait([
        APIService().getVendorParts(h.brand, h.partNo),
        APIService()
            .getPartsByHunterNo(h.hunter)
            .then((PartModel v) => APIService().getVehicleByVin(v.vin)),
      ]),
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
              return snapshot.data[0].length > 0
                  ? buildPriceWrapper(
                      context, snapshot.data[0], snapshot.data[1])
                  : buildMakeARequestButton(context);
            }
        }
      },
    );
  }

  Column buildPriceWrapper(BuildContext context, List<VendorModel> vendor,
      VehicleModel vehicleData) {
    if (context.mounted) {
      // Future.delayed(const Duration(seconds: 1));
      SchedulerBinding.instance
          .addPostFrameCallback((_) => vehicle = vehicleData);
    }

    /// Filtering for Min-Price without OPM
    VendorModel minPriceWithoutOPM =
        vendor.reduce((VendorModel curr, VendorModel next) {
      return (curr.stockStatus == "instock" && next.stockStatus == "instock") &&
              (curr.opm == "no" && curr.opm == "no") &&
              curr.currentPrice < next.currentPrice
          ? curr
          : next;
    });

    /// Filtering for Min-Price with OPM
    VendorModel minPriceWithOPM = vendor.first;
    for (var e in vendor) {
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
              buildContainerImage(),
              buildProductInfo(minPriceWithoutOPM),
            ],
          ),
        },
        if (minPriceWithOPM.stockStatus == "instock" &&
            minPriceWithOPM.opm == "yes" &&
            minPriceWithoutOPM.productAge == productAge) ...{
          const Divider(height: 1.0),
          buildBadge(context, minPriceWithOPM, isRadius: false),
          Row(
            children: [
              buildContainerImage(),
              buildProductInfo(minPriceWithOPM),
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
          child: buildBadgeText(
              "${vendor.brand} ${opmCheck(vendor.opm)}${vendor.brandType}",
              context),
          isRadius: isRadius,
        ),
        buildBadgeBg(
          child: buildBadgeText(vendor.productAge, context),
          isRadius: false,
          radiusRight: true,
        ),
      ],
    );
  }

  Text buildBadgeText(String label, BuildContext context) {
    return Text(
      label.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: getProportionateScreenWidth(10),
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onPrimary,
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

  buildProductInfo(VendorModel product) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            product.partNo.toUpperCase(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: getProportionateScreenHeight(20)),
          Text(
            "$ghCediSign ${product.currentPrice}",
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
        () => animateTransition(context, PartsByPartNo(cPart: widget.cPart)),
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
