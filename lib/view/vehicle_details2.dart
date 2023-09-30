import 'package:automasters/models/animation_item.dart';
import 'package:automasters/models/parts.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/view/part_details.dart';
import 'package:automasters/view/part_list.dart';
import 'package:automasters/utils/animation_transition.dart';
import 'package:automasters/utils/constants.dart';
import 'package:automasters/view/home.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:automasters/widgets/scale_animation.dart';
import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../service/apiService.dart';

class VehicleDetails extends StatefulWidget {
  final VehicleModel vehicle;

  const VehicleDetails({super.key, required this.vehicle});

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails>
    with SingleTickerProviderStateMixin {
  // Animation setups
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];

  late Future<List<PartModel>> partsQuery;

  // Keep track of selected car index;
  int selectedIndex = 0;

  final _tabs = List.generate(10, (index) => 'Tab#${index + 1}');

  late final TabController _tabCont;

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
                onTap: () => animateTransition(context, Home(vin: widget.vehicle.vin)),
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
        body: buildPartsDetails(context),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Container(
        height: SizeConfig.screenHeight!,
        width: SizeConfig.screenWidth!,
        child: SingleChildScrollView(
          primary: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: kToolbarHeight),
                    buildTopNavbar(context),
                    const SizedBox(height: 15.0),
                    buildVehicleName(),
                    AnimatedSwitcher(
                      // This switcher doesn't work, flutter can't
                      // understand the child change without a key property here
                      // I will include a link to a video talking more about keys
                      duration: const Duration(milliseconds: 500),
                      child: ScaleAnimation(
                        key: const ValueKey("assets/car3.png"),
                        duration: getSlideDuration("slide-3", animationItems),
                        direction: getItemVisibility("slide-3", animationItems),
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset("assets/car3.png"),
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                    Text(
                      "customTheme,context",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 100),
                    Text(
                      "customTheme,context",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 100),
                    Text(
                      "customTheme,context",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 100),
                    Text(
                      "customTheme,context",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 100),
                    Text(
                      "customTheme,context",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 100),
                    Text(
                      "customTheme,context",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 100),
                    Text(
                      "customTheme,context",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 100),
                    Text(
                      "customTheme,context",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 100),
                    Text(
                      "customTheme,context",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              /*Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const SizedBox(height: kToolbarHeight),
                        buildTopNavbar(context),
                        const SizedBox(height: 15.0),
                        buildVehicleName(),
                        const SizedBox(height: 10.0),
                        buildVehicleImage(),
                      ],
                    ),
                  ),
                ),*/
              // buildPartsDetails(context),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  FadeSlide buildTopNavbar(BuildContext context) {
    return FadeSlide(
      direction: getItemVisibility("slide-1", animationItems),
      duration: getSlideDuration("slide-1", animationItems),
      offsetY: 60.0,
      offsetX: 0.0,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => animateTransition(context, const Home()),
            child: Container(
              height: 55.0,
              width: 55.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: const Icon(Icons.chevron_left
                  //FlutterIcons.chevron_left_fea,
                  ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 55.0,
              width: 55.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: const Icon(
                  //MIcon.riMenu2Line,
                  Icons.line_style),
            ),
          ),
        ],
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
          key: const ValueKey("assets/car3.png"),
          duration: getSlideDuration("slide-3", animationItems),
          direction: getItemVisibility("slide-3", animationItems),
          child: Align(
            alignment: Alignment.center,
            child: Image.asset("assets/car3.png"),
          ),
        ),
      ),
    );
  }

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
        child: FutureBuilder<List<PartModel>>(
          future: partsQuery,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              default:
                if (snapshot.hasError) {
                  return const Text('Refresh App');
                } else {
                  return ListView(
                    primary: false,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    // mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _getTabItem("Select Your Parts", true),
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
                      buildListView(snapshot.data),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Widget buildListView(result) {
    return result != null && result.length > 0
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: result.map<Widget>((PartModel carPart) {
              return Container(
                width: double.infinity,
                color: Colors.grey.shade300,
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                margin: const EdgeInsets.only(top: 5.0),
                child: GestureDetector(
                  child: Text(
                    carPart.part.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  onTap: () {
                    // We then need to change page route
                    // Lets create an animated router and the page
                    // We want to navigate to
                    animateTransition(context,
                        PartDetails(carParts: result, vehicle: widget.vehicle));
                  },
                ),
              );
            }).toList(),
          )
        : const SizedBox.shrink();
    /*return ListView.separated(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: result.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          PartModel carPart = result[index];
          return result.length > 0
              ? Container(
                  color: Colors.grey.shade400,
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: GestureDetector(
                    child: Text(
                      carPart.part.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    onTap: () {
                      // We then need to change page route
                      // Lets create an animated router and the page
                      // We want to navigate to
                      animateTransition(
                          context,
                          PartDetails(
                              carParts: result, vehicle: widget.vehicle));
                    },
                  ),
                )
              : const SizedBox.shrink();
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 5.0,
        ),
      );*/
  }
}

Widget _getTabItem(String text, bool isActive) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: TextStyle(
          color:
              isActive ? const Color(0xFF333333) : Colors.black.withOpacity(.5),
          fontSize: isActive ? 18.0 : 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      isActive
          ? Container(
              margin: const EdgeInsets.only(top: 5.0),
              height: 4.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: isActive ? kPrimaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
            )
          : const SizedBox.shrink()
    ],
  );
}
