import 'package:automasters/models/animation_item.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';

import '../models/hunter.dart';
import '../models/vehicle.dart';
import '../widgets/widgetery.dart';

class PartDetailsCheckout extends StatefulWidget {
  final HunterModel huntPart;
  final VehicleModel vehicle;

  const PartDetailsCheckout(
      {super.key, required this.huntPart, required this.vehicle});

  @override
  State<PartDetailsCheckout> createState() => _PartDetailsCheckoutState();
}

class _PartDetailsCheckoutState extends State<PartDetailsCheckout>
    with SingleTickerProviderStateMixin {
  // Animation setups
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];

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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) => [buildSliverAppBar()],
        body: buildPartDetails(context),
      ),
    );
  }

  SliverAppBar buildSliverAppBar() {
    return buildSliverAppBars(
            context,
            getProportionateScreenHeight(250),
            buildBackButton(context),
            FlexibleSpaceBar(
              centerTitle: true,
              background: buildPartsImage(),
              title: buildPartName(),
              collapseMode: CollapseMode.pin,
            ),
            preferredSize: buildPreferredSize("SKU: ${widget.huntPart.sku}"),
          );
  }

  Container buildPartName() {
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
        child: buildRichText(widget.huntPart.product, "${vehicle.year} ${vehicle.make} ${vehicle.model}"),
      ),
    );
  }

  Container buildPartsImage() {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      // Lets create a list of all car image colors
      child: buildAnimatedSwitcher(Image.asset("assets/part-p.png"), animationItems),
    );
  }

  FadeSlide buildPartDetails(BuildContext context) {
    return buildFadeSlide(
      animationItems,
      child: buildCurveContainer(
        const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 32.0,
        ),
        child: buildProductDetails(context),
      ),
    );
  }

  Column buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customLine("Product Details", true, context),
        const Divider(),
        ListTile(
          title: Text(widget.huntPart.product.capitalizeEach()),
          subtitle: Text(
            "${widget.huntPart.brand}\nPART NUMBER: ${widget.huntPart.partNo}".capitalizeEach(),
          ),
        ),
        ListTile(
          title: const Text("Note"),
          subtitle: Text(
            "${widget.huntPart.product.capitalize()} are a component of a vehicle's front suspension system. They connect the control arms and steering knuckles. Ball joints are similar to the hip joint in the human body.",
          ),
        ),
        const Divider(),
        buildCheckoutButton(context)
      ],
    );
  }

  Row buildCheckoutButton(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(
              color: Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          child: const Icon(Icons.heart_broken, color: Colors.white),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                width: 1.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: () {},
            child: const Text("Checkout"),
          ),
        )
      ],
    );
  }
}
