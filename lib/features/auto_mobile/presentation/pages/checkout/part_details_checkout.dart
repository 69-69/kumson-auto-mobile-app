import 'package:flutter/material.dart';
import 'package:automasters/core/constants/constants.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/data/models/custom_appbar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_line.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:automasters/features/auto_mobile/data/models/hunter.dart';
import 'package:automasters/features/auto_mobile/data/models/vehicle.dart';
import 'package:string_capitalize/string_capitalize.dart';

class PartDetailsCheckout extends StatelessWidget {
  final Map<String, dynamic> data;

  const PartDetailsCheckout({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    HunterModel huntPart = data['hunter'] as HunterModel;
    VehicleModel vehicle = data['vehicle'] as VehicleModel;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: NestedScrollView(
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (_, __) {
          CustomAppBarModel appBarInfo = CustomAppBarModel(
            title: huntPart.product!,
            subTitle: "${vehicle.year} ${vehicle.make} ${vehicle.model}",
            subMiniTitle: "SKU: ${huntPart.sku}",
            imageUrl: kDefaultPartImage,
            videoUrl: 'https://youtu.be/EgF01aSQyno?si=HBUGAORJ-DPVH0CY',
            expandedHeight: getProportionateScreenHeight(250),
          );

          return [CustomSliverAppBar(data: appBarInfo)];
        },
        body: _buildBody(context, huntPart),
        //
      ),
    );
  }

  Widget _buildBody(BuildContext context, HunterModel huntPart) {
    return buildCurveContainer(
      context,
      const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customLine("Product Details", context),
          const Divider(),
          ListTile(
            title: Text(huntPart.product!.capitalizeEach()),
            subtitle: Text(
              "${huntPart.brand}\nPART NUMBER: ${huntPart.partNo}"
                  .capitalizeEach(),
            ),
          ),
          ListTile(
            title: const Text("Note"),
            subtitle: Text(
              "${huntPart.product!.capitalize()} are a component of a vehicle's front suspension system. They connect the control arms and steering knuckles. Ball joints are similar to the hip joint in the human body.",
            ),
          ),
          const Divider(),
          buildCheckoutButton(context)
        ],
      ),
    );
  }

  Row buildCheckoutButton(BuildContext context) {
    ColorScheme tColor = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: tColor.background,
            border: Border.all(
              color: tColor.surfaceTint,
            ),
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          child: Icon(Icons.heart_broken, color: tColor.primary),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: buildOutlinedBtn(
            context,
            label: "Checkout",
            onPress: () {},
          ),
        )
      ],
    );
  }
}
