import 'package:automasters/models/animation_item.dart';
import 'package:automasters/models/car.dart';
import 'package:automasters/view/part_list.dart';
import 'package:automasters/utils/constants.dart';
import 'package:automasters/utils/router.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:flutter/material.dart';

final List<Car> cars = [
  Car(
    image: Image.asset(
      "assets/car3.png",
      width: 150.0,
    ),
    name: "BMW 3 Series",
    stock: 6,
  ),
  Car(
    image: Image.asset(
      "assets/carbig.png",
      width: 150.0,
    ),
    name: "BMW 3 Series",
    stock: 6,
  ),
  Car(
    image: Image.asset(
      "assets/car4.png",
      width: 150.0,
    ),
    name: "BMW 3 Series",
    stock: 6,
  ),
  Car(
    image: Image.asset(
      "assets/car1.png",
      width: 150.0,
    ),
    name: "BMW 3 Series",
    stock: 6,
  ),
  Car(
    image: Image.asset(
      "assets/car3.png",
      width: 150.0,
    ),
    name: "BMW 3 Series",
    stock: 6,
  ),
  Car(
    image: Image.asset(
      "assets/carbig.png",
      width: 150.0,
    ),
    name: "BMW 3 Series",
    stock: 6,
  ),
  Car(
    image: Image.asset(
      "assets/car4.png",
      width: 150.0,
    ),
    name: "BMW 3 Series",
    stock: 6,
  ),
  Car(
    image: Image.asset(
      "assets/car1.png",
      width: 150.0,
    ),
    name: "BMW 3 Series",
    stock: 6,
  ),
];

class CarsModal extends StatefulWidget {
  @override
  _CarsModalState createState() => _CarsModalState();
}

class _CarsModalState extends State<CarsModal>
    with SingleTickerProviderStateMixin {
  List<AnimationItem> animationItems = [
    AnimationItem(
      id: "slide-1",
      entry: 30,
      entryDuration: 300,
      visible: false,
    ),
    AnimationItem(
      id: "slide-2",
      entry: 30,
      entryDuration: 300,
      visible: false,
    ),
    AnimationItem(
      id: "slide-3",
      entry: 35,
      entryDuration: 300,
      visible: false,
    ),
    AnimationItem(
      id: "slide-4",
      entry: 40,
      entryDuration: 300,
      visible: false,
    ),
    AnimationItem(
      id: "slide-5",
      entry: 43,
      entryDuration: 300,
      visible: false,
    ),
    AnimationItem(
      id: "slide-6",
      entry: 46,
      entryDuration: 300,
      visible: false,
    ),
    AnimationItem(
      id: "slide-7",
      entry: 49,
      entryDuration: 300,
      visible: false,
    ),
    AnimationItem(
      id: "slide-8",
      entry: 52,
      entryDuration: 300,
      visible: false,
    ),
    AnimationItem(
      id: "slide-9",
      entry: 55,
      entryDuration: 300,
      visible: false,
    ),
    AnimationItem(
      id: "slide-10",
      entry: 58,
      entryDuration: 300,
      visible: false,
    ),
    AnimationItem(
      id: "slide-11",
      entry: 61,
      entryDuration: 300,
      visible: false,
    ),
    AnimationItem(
      id: "slide-12",
      entry: 64,
      entryDuration: 300,
      visible: false,
    ),
  ];
  late AnimationController animationController;
  late Animation animation;
  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 65).animate(animationController)
      ..addListener(() {
        setState(() {
          animationItems = updateVisibleState(animationItems, animation.value);
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520.0,
      padding: const EdgeInsets.symmetric(
        vertical: 30.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 15.0,
          ),
          FadeSlide(
            direction: !getItemVisibility("slide-1", animationItems),
            offsetX: 0.0,
            offsetY: 150,
            duration: getSlideDuration("slide-1", animationItems),
            child: Image.asset(
              "assets/bmw.png",
              width: 50.0,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          FadeSlide(
            direction: !getItemVisibility("slide-2", animationItems),
            offsetX: 0.0,
            offsetY: 150,
            duration: getSlideDuration("slide-2", animationItems),
            child: const Text(
              "BMW",
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                fontWeight: FontWeight.bold,
                fontSize: 27.0,
                // color: kPrimaryColor,
              ),
            ),
          ),
          FadeSlide(
            direction: !getItemVisibility("slide-3", animationItems),
            offsetX: 0.0,
            offsetY: 150,
            duration: getSlideDuration("slide-3", animationItems),
            child: const Text(
              "8 Series",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
                // color: kPrimaryColor,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
            height: 200.0,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return FadeSlide(
                  direction:
                      !getItemVisibility("slide-${index + 4}", animationItems),
                  offsetX: 0.0,
                  offsetY: 150,
                  duration:
                      getSlideDuration("slide-${index + 4}", animationItems),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: 130.0,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE4E4EE),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: cars[index].image,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        cars[index].name + " ${index + 4}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        "${cars[index].stock} Cars",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 20.0,
                );
              },
              itemCount: 8,
            ),
          ),
          const SizedBox(
            height: 35.0,
          ),
          FadeSlide(
            direction: !getItemVisibility("slide-12", animationItems),
            offsetX: 0.0,
            offsetY: 150,
            duration: getSlideDuration("slide-12", animationItems),
            child: Container(
              width: MediaQuery.of(context).size.width * .7,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 22.0)
                    )
                ),
                onPressed: () {
                  animationController.forward()
                    .then(
                      (value) {
                        // animateTransition(context, CarsList());
                      },
                    );
                },
                child: const Text(
                  "View All",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
