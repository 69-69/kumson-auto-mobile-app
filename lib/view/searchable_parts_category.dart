import 'package:automasters/models/parts.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/view/part_list.dart';
import 'package:automasters/utils/animation_transition.dart';
import 'package:automasters/view/parts_by_price.dart';
import 'package:automasters/view/parts_cross_ref.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';
import '../models/vehicle.dart';
import '../widgets/show_confirmation_dialog.dart';
import '../widgets/widgetery.dart';
import '../utils/keyboard.dart';

class SearchablePartsCategory extends StatelessWidget {
  final FocusNode focusNode;
  final VehicleModel vehicle;
  final List<PartModel> carParts;

  SearchablePartsCategory({
    super.key,
    required this.vehicle,
    required this.carParts,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return searchableProducts(context, carParts);
  }

  Widget searchableProducts(BuildContext context, pro) {
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
            // fillColor: const Color(0xFFF0EEF6),
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
            const Divider(indent: 40),
            Expanded(child: buildListView(carParts, isSearching, filtered)),
            buildSearchField(),
          ],
        );
      },
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
        customLine("Select Your Part", context),
        TextButton(
          onPressed: () {
            animateTransition(
              context,
              PartList(carParts: carParts, vehicle: vehicle),
            );
          },
          child: const Text("See All"),
        ),
      ],
    );
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
      key: UniqueKey(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: searching ? filtered.value.length : result.length,
      itemBuilder: (context, index) {
        PartModel item = searching ? filtered.value[index] : result[index];

        return buildCard(item, context);
      },
    );
  }

  buildCard(PartModel item, BuildContext context) {
    return item.part != "0" ? Card(
      elevation: 3.0,
      // color: const Color(0xFFF0EEF6), //Colors.grey.shade300,
      margin: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.part.capitalizeEach(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const Icon(Icons.arrow_forward, size: 14),
            ],
          ),
        ),
        onTap: () async {
          final isPrice = await showConfirmationDialog(
            context,
            positiveResponse: "Price",
            negativeResponse: "Cross Ref",
            const Text("Shop by Price or Cross Reference?"),
          );
          if (context.mounted) {
            if (isPrice != "cancel") {
              animateTransition(
                  context,
                  isPrice
                      ? PartsByPrice(cPart: item, vehicle: vehicle)
                      : PartsCrossRef(cPart: item, vehicle: vehicle));
            }
          }
        },
      ),
    ) : const SizedBox.shrink();
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
