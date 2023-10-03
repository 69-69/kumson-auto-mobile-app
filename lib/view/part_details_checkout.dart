import 'package:automasters/models/animation_item.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:automasters/widgets/scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';

import '../models/hunter.dart';
import '../models/vehicle.dart';
import '../utils/custom_line.dart';

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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverAppBar(
              primary: true,
              pinned: true,
              floating: false,
              centerTitle: true,
              expandedHeight: 250,
              leadingWidth: 100,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // animateTransition(context, PartsCategory(cPart: widget.carParts[0], vehicle: widget.vehicle));
                },
                child: buildBackButton(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: buildPartsImage(),
                title: buildPartName(),
                collapseMode: CollapseMode.pin,
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.0),
                child: Transform.translate(
                  offset: const Offset(0, 50),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text("SKU: ${widget.huntPart.sku}"),
                  ),
                ),
              ),
              /*shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),*/
            ),
          ];
        },
        physics: const BouncingScrollPhysics(),
        body: buildPartDetails(context),
      ),
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
    VehicleModel vehicle = widget.vehicle;

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
                    "${widget.huntPart.product.capitalizeEach()}\n",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              TextSpan(
                text: "${vehicle.year} ${vehicle.make} ${vehicle.model}".capitalizeEach(),
                style: const TextStyle(
                  height: 1.7,
                  fontSize: 13.0,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildPartsImage() {
    return Container(
      margin: const EdgeInsets.only(top: 60),
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

  FadeSlide buildPartDetails(BuildContext context) {
    return FadeSlide(
      duration: getSlideDuration("slide-4", animationItems),
      direction: getItemVisibility("slide-4", animationItems),
      offsetX: 0.0,
      offsetY: 60.0,
      child: Container(
        height: 360.0,
        width: double.infinity,
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
