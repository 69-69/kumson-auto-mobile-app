import 'package:automasters/models/animation_item.dart';
import 'package:automasters/models/parts.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/view/part_list.dart';
import 'package:automasters/utils/animation_transition.dart';
import 'package:automasters/view/home.dart';
import 'package:automasters/view/parts_category.dart';
import 'package:automasters/widgets/fade_slide.dart';
import 'package:automasters/widgets/scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';

import '../models/vehicle.dart';
import '../service/apiService.dart';
import '../utils/custom_line.dart';
import '../utils/keyboard.dart';

class VehicleDetails extends StatefulWidget {
  final VehicleModel vehicle;

  const VehicleDetails({super.key, required this.vehicle});

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
    getCarParts = APIService().getPartsByVfam(widget.vehicle.vfam);

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
    //build/app/outputs/flutter-apk/app-debug.apk.
    //Installing build/app/outputs/flutter-apk/app-debug.apk.
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        headerSliverBuilder: (_, __) {
          return [
            buildSliverAppBar(context),
          ];
        },
        body: buildPartsDetails(context),
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      primary: true,
      scrolledUnderElevation: 5.0,
      pinned: true,
      floating: false,
      centerTitle: true,
      expandedHeight:
          getProportionateScreenHeight(focusNode.hasPrimaryFocus ? 100 : 250),
      leadingWidth: 100,
      leading: GestureDetector(
        onTap: () => animateTransition(context, Home(vin: widget.vehicle.vin)),
        child: buildBackButton(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
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
            child: Text("${widget.vehicle.make} - ${widget.vehicle.model}"),
          ),
        ),
      ),
      /*shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),*/
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

  buildVehicleName() {
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
                text: "${vehicle.model.capitalizeEach()}\n",
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
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

  Container buildVehicleImage() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: AnimatedSwitcher(
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
        padding: const EdgeInsets.fromLTRB(
          24.0,32.0,24.0,0.0,
        ),
        child: buildFutureBuilder(),
      ),
    );
  }

  FutureBuilder<List<PartModel>> buildFutureBuilder() {
    return FutureBuilder<List<PartModel>>(
      future: getCarParts,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // By default, show a loading spinner.
            return buildProgressBar();
          default:
            if (snapshot.hasError) {
              return const Text('Refresh App');
            } else {
              List<PartModel> result = snapshot.data;
              return snapshot.data.length > 0
                  ? searchableProducts(result)
                  : buildMakeRequestButton(context);
            }
        }
      },
    );
  }

  Center buildMakeRequestButton(BuildContext context) {
    return Center(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 1.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Make a Request"),
                    ),
                  );
  }

  UnderlineInputBorder enabledBorder() {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    );
  }

  UnderlineInputBorder focusedBorder() {
    /*focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(25.7),
    ),*/
    return const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    );
  }

  /// List View Header[buildListViewHeader]
  Row buildListViewHeader(BuildContext context, List<PartModel> carParts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customLine("Select Your Part", true, context),
        TextButton(
          onPressed: () {
            animateTransition(
              context,
              PartList(carParts: carParts, vehicle: widget.vehicle),
            );
          },
          child: const Text("See All"),
        ),
      ],
    );
  }

  Widget searchableProducts(pro) {
    bool isSearching = false;
    List<PartModel> carParts = pro;
    ValueNotifier<List<PartModel>> filtered =
        ValueNotifier<List<PartModel>>([]);
    TextEditingController searchController = TextEditingController();

    prefixIcon() =>
        Icon(Icons.search, color: Color(isSearching ? 0xFFD5300C : 0xFF979797));

    suffixIcon() => IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF979797)),
          onPressed: () {
            searchController.clear();
            isSearching = false;
            filtered.value = [];
          },
        );

    Container buildSearchField() {
      final txtFieldKey = GlobalKey<State<StatefulWidget>>();

      return Container(
        height: getProportionateScreenHeight(40.0),
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
        child: TextField(
          focusNode: focusNode,
          controller: searchController,
          decoration: InputDecoration(
            filled: true,
            focusedBorder: focusedBorder(),
            enabledBorder: enabledBorder(),
            focusColor: Colors.grey,
            fillColor: const Color(0xFFF0EEF6),
            //Colors.grey.shade300,
            contentPadding: EdgeInsets.all(
              getProportionateScreenHeight(10),
            ),
            hintText: "...filter Parts",
            prefixIcon: prefixIcon(),
            suffixIcon: isSearching ? suffixIcon() : const SizedBox.shrink(),
          ),
          onTap: () => ensureVisibleOnTextArea(textFieldKey: txtFieldKey),
          onTapOutside: (event) {
            KeyboardUtil.hide(context);
            focusNode.unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
            TextEditingController().clear();
            // FocusScope.of(context).unfocus();
          },
          onChanged: (val) {
            filtered.value = [];
            if (val.isNotEmpty) {
              isSearching = true;
              // Start filtering list of products
              filterCondition(carParts, val, filtered);
            } else {
              isSearching = false;
            }
          },
        ),
      );
    }

    return ValueListenableBuilder<List>(
      valueListenable: filtered,
      builder: (context, value, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildListViewHeader(context, carParts),
            const Divider(thickness: 2, indent: 40),
            Expanded(child: buildListView(carParts, isSearching, filtered)),
            buildSearchField(),
          ],
        );
      },
    );
  }

  Future<void> ensureVisibleOnTextArea(
      {required GlobalKey textFieldKey}) async {
    final keyContext = textFieldKey.currentContext;
    if (keyContext != null) {
      await Future.delayed(const Duration(milliseconds: 500)).then(
        (value) => Scrollable.ensureVisible(
            keyContext,
            duration: const Duration(milliseconds: 200),
            curve: Curves.decelerate,
          ),
      );
      // Optional if doesnt work with the first
      // await Future.delayed(const Duration(milliseconds: 500)).then(
      //   (value) => Scrollable.ensureVisible(
      //     keyContext,
      //     duration: const Duration(milliseconds: 200),
      //     curve: Curves.decelerate,
      //   ),
      // );
    }
  }

  /// Filter list of products[filterCondition]
  filterCondition(List<PartModel> products, String term, filtered) {
    for (var product in products) {
      if (product.part.toString().toLowerCase().contains(term)) {
        // add results to list array
        filtered.value.add(product);
      }
    }
    return filtered.value;
  }

  /// List view display[buildListView]
  buildListView(
      result, bool searching, ValueNotifier<List<PartModel>> filtered) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: searching ? filtered.value.length : result.length,
      itemBuilder: (context, index) {
        PartModel item = searching ? filtered.value[index] : result[index];

        return buildCard(item, context);
      },
    );
  }

  Card buildCard(PartModel item, BuildContext context) {
    return Card(
      elevation: 3.0,
      color: const Color(0xFFF0EEF6), //Colors.grey.shade300,
      margin: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.part.capitalizeEach(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Icon(Icons.arrow_forward, size: 16),
            ],
          ),
        ),
        onTap: () => animateTransition(
            context, PartsCategory(cPart: item, vehicle: widget.vehicle)),
      ),
    );
  }
}

/*return Scaffold(
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
    );*/
