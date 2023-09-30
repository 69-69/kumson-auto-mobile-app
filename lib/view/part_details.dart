import 'package:automasters/models/animation_item.dart';
import 'package:automasters/models/parts.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/utils/animation_transition.dart';
import 'package:automasters/view/parts_category.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:automasters/widgets/scale_animation.dart';
import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../service/apiService.dart';
import '../utils/custom_line.dart';

class PartDetails extends StatefulWidget {
  final List<PartModel> carParts;
  final VehicleModel vehicle;

  const PartDetails({super.key, required this.carParts, required this.vehicle});

  @override
  State<PartDetails> createState() => _PartDetailsState();
}

class _PartDetailsState extends State<PartDetails>
    with SingleTickerProviderStateMixin {
  // Animation setups
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];

  late Future<List<PartModel>> partsQuery;

  // Keep track of selected car index;
  int selectedIndex = 0;

  @override
  void initState() {
    partsQuery = APIService().getPartsByVfam(widget.vehicle.vfam);

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
                onTap: () => animateTransition(context, PartsCategory(cPart: widget.carParts[0], vehicle: widget.vehicle)),
                child: Container(
                  height: 55.0,
                  width: 55.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: const Icon(Icons.chevron_left),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: buildVehicleImage(),
                title: buildVehicleName(),
                collapseMode: CollapseMode.pin,
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.0),
                child: Transform.translate(
                  offset: const Offset(0, 50),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                        "${widget.vehicle.make} - ${widget.vehicle.model}"),
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

  FadeSlide buildVehicleName() {
    VehicleModel vehicle = widget.vehicle;

    return FadeSlide(
      direction: getItemVisibility("slide-2", animationItems),
      duration: getSlideDuration("slide-2", animationItems),
      offsetY: 60.0,
      offsetX: 0.0,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "${vehicle.make} - ${vehicle.model}\n",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22.0,
                color: Color(0xFFFFFFFF),
              ),
            ),
            TextSpan(
              text: "${vehicle.category} - ${vehicle.fuelType}",
              style: const TextStyle(
                height: 1.7,
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildVehicleImage() {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                customLine("Inspire", true, context),
                const SizedBox(
                  width: 15.0,
                ),
                customLine("Inform", false, context),
                const SizedBox(
                  width: 15.0,
                ),
                customLine("Technical Data", false, context),
              ],
            ),
            const SizedBox(
              height: 25.0,
            ),
            Text(
              "Hello there, thank you for coming here, please dont forget to subscribe and like this video if you learnt something from it",
              style: TextStyle(
                height: 1.5,
                fontSize: 16.0,
                color: Colors.black.withOpacity(.5),
              ),
            ),
            const SizedBox(height: 15.0),
            const Divider(),
            const SizedBox(height: 15.0),
            Row(
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                  ),
                  child: const Icon(
                    // FlutterIcons.heart_fea,
                      Icons.heart_broken),
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Container(
                    width: SizeConfig.screenWidth! * .7,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 22.0))),
                      onPressed: () {},
                      child: const Text(
                        "Checkout",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}
