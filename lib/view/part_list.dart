import 'package:automasters/models/animation_item.dart';
import 'package:automasters/view/part_details.dart';
import 'package:automasters/utils/animation_transition.dart';
import 'package:automasters/view/vehicle_details.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:flutter/material.dart';

import '../models/parts.dart';
import '../models/vehicle.dart';

class PartList extends StatefulWidget {
  final List<PartModel> carParts;
  final VehicleModel vehicle;

  const PartList({super.key, required this.carParts, required this.vehicle});

  @override
  State<PartList> createState() => _PartListState();
}

class _PartListState extends State<PartList>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  List<AnimationItem> animationItems = [];

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Loop through and create animations

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
          animationItems = updateVisibleState(animationItems, animation.value);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SafeArea(child: SizedBox.shrink()),
              // Lets make setups for animations
              FadeSlide(
                offsetX: 0.0,
                offsetY: 60.0,
                duration: getSlideDuration("slide-1", animationItems),
                direction: getItemVisibility("slide-1", animationItems),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                VehicleDetails(vehicle: widget.vehicle),
                          ),
                        );
                      },
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
                  ],
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              buildHeader(),
              buildListView()
            ],
          ),
        ),
      ),
    );
  }

  FadeSlide buildHeader() {
    return FadeSlide(
      offsetX: 0.0,
      offsetY: 60.0,
      duration: getSlideDuration("slide-2", animationItems),
      direction: getItemVisibility("slide-2", animationItems),
      child: const Text(
        "Choose your\n car part!",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
          fontSize: 18,
          height: 1.3,
        ),
      ),
    );
  }

  ListView buildListView() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.carParts.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        PartModel cPart = widget.carParts[index];

        return FadeSlide(
          offsetX: 0.0,
          offsetY: 60.0,
          duration: getSlideDuration("slide-${index + 1}", animationItems),
          direction: getItemVisibility("slide-${index + 1}", animationItems),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
            height: 190.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEF6),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: GestureDetector(
              onTap: () {
                animateTransition(
                  context,
                  PartDetails(
                    carParts: widget.carParts,
                    vehicle: widget.vehicle,
                  ),
                );
              },
              child: buildBody(cPart),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 10.0,
      ),
    );
  }

  Row buildBody(PartModel cPart) {
    return Row(
      children: [
        Expanded(
          child: Image.asset("assets/part-p.png"),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cPart.part.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              "Model: ${cPart.model}",
              style: TextStyle(color: Colors.grey.shade800),
            ),
            Text("Make: ${cPart.make}")
          ],
        )
      ],
    );
  }
}
