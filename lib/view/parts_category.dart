import 'package:automasters/models/animation_item.dart';
import 'package:automasters/models/parts.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/view/part_details.dart';
import 'package:automasters/view/part_list.dart';
import 'package:automasters/utils/animation_transition.dart';
import 'package:automasters/view/vehicle_details.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:automasters/widgets/scale_animation.dart';
import 'package:flutter/material.dart';

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
                onTap: () => animateTransition(context, VehicleDetails(vehicle: widget.vehicle)),
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
  }

  FadeSlide buildVehicleName() {
    PartModel _cPart = widget.cPart;

    return FadeSlide(
      direction: getItemVisibility("slide-2", animationItems),
      duration: getSlideDuration("slide-2", animationItems),
      offsetY: 60.0,
      offsetX: 0.0,
      child: Text.rich(
        TextSpan(
          children: [

            TextSpan(
              text: "${TextTools.toUppercaseFirstLetterEach(_cPart.part)} - ${_cPart.make}\n",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22.0,
                color: Color(0xFFFFFFFF),
              ),
            ),
            TextSpan(
              text: "${_cPart.make} - ${_cPart.model}",
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
                return buildProgressBar();
              default:
                if (snapshot.hasError) {
                  return const Text('Refresh App');
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customLine(widget.cPart.part.toUpperCase(), true, context),
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
                      Expanded(
                        child: buildListView1(snapshot.data),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
  /// List view display[buildListView1]
  buildListView1(
      result) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: result.length,
      itemBuilder: (context, index) {
        final carPart = result[index];

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
                  TextTools.toUppercaseFirstLetterEach(carPart.part),
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
      },
    );
  }


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
  }
}
