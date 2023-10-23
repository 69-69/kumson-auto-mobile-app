import 'package:automasters/models/animation_item.dart';
import 'package:automasters/models/parts.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/view/home.dart';
import 'package:automasters/view/filter_parts_category.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../service/api_service.dart';
import '../widgets/async_progress_dialog.dart';
import '../widgets/widgetery.dart';

class VehicleDetails extends StatefulWidget {
  final VehicleModel vehicle;
  final List<PartModel>? parts;

  const VehicleDetails({
    super.key,
    required this.vehicle,
    this.parts,
  });

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails>
    with SingleTickerProviderStateMixin {
  final FocusNode focusNode = FocusNode();

  // Animation setups
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];

  late Future<List<PartModel>> getCarParts;

  @override
  void initState() {
    getCarParts = APIService().getPartsByVFAM(widget.vehicle.vfam);

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
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) => [buildSliverAppBar(context)],
        body: buildPartsDetails(context),
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) => buildSliverAppBars(
        context,
        getProportionateScreenHeight(focusNode.hasPrimaryFocus ? 100 : 250),
        buildBackButton(context, route: Home(vin: widget.vehicle.vin)),
        FlexibleSpaceBar(
          centerTitle: true,
          background: buildVehicleImage(),
          title: buildVehicleName(),
          collapseMode: CollapseMode.pin,
        ),
        preferredSize: buildPreferredSize(
            "${widget.vehicle.make} - ${widget.vehicle.model}"),
      );

  Container buildVehicleName() {
    VehicleModel vehicle = widget.vehicle;

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
            vehicle.model, "${vehicle.year} ${vehicle.make} ${vehicle.model}"),
      ),
    );
  }

  Container buildVehicleImage() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child:
          buildAnimatedSwitcher(Image.asset("assets/car3.png"), animationItems),
    );
  }

  FadeSlide buildPartsDetails(BuildContext context) {
    return buildFadeSlide(
      animationItems,
      child: buildCurveContainer(
        const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0.0),
        child: widget.parts == null
            ? buildFutureBuilder()
            : FilterPartsCategory(focusNode: focusNode,
                vehicle: widget.vehicle, carParts: widget.parts!),
      ),
    );
  }

  FutureBuilder<List<PartModel>> buildFutureBuilder() {
    return FutureBuilder<List<PartModel>>(
      future: getCarParts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // By default, show a loading spinner
            return showCircularProgress();
          default:
            if (snapshot.hasError) {
              return const Text('Refresh App');
            } else {
              List<PartModel> result = snapshot.data;
              return snapshot.data.length > 0
                  ? FilterPartsCategory(focusNode: focusNode,
                      vehicle: widget.vehicle, carParts: result)
                  : buildMakeARequestButton(context);
            }
        }
      },
    );
  }
}
