import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/by_cross_ref/cross_ref_request_form.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/part_no_request_form.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/vin_request_form.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/part/part_request_form.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/manual_request_form.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/build_modal.dart';

/// Show by user's click Modal-dialog-Button [showMakeRequestButton]
showMakeRequestButton(
  BuildContext context,
  String reqType, {
  Color? borderColor,
}) =>
    SizedBox(
      width: SizeConfig.screenWidth,
      child: buildOutlinedBtn(
        context,
        label: "Make Request",
        borderColor: borderColor,
        onPress: () => showRequestModal(context, reqType),
      ),
    );

/// Show Modal-dialog automatically [showRequestModal]
showRequestModal(BuildContext context, String reqType) =>
    buildModal(context, MakeARequestModal(reqType: reqType));

class MakeARequestModal extends StatefulWidget {
  final String reqType;

  const MakeARequestModal({super.key, required this.reqType});

  @override
  State<MakeARequestModal> createState() => _MakeARequestModalState();
}

class _MakeARequestModalState extends State<MakeARequestModal> {
  bool isClick = false;

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    // KeyboardUtil.hide(context);

    final height = isClick || widget.reqType == "manualRequest";

    return IntrinsicHeight(
    /*return SizedBox(
      height: SizeConfig.screenHeight! * (height ? 0.7 : 0.17),*/
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (height) ...{
            _buildTitle(context),
            const Divider(thickness: 1),
          },
          _buildBody(context),
        ],
      ),
    );
  }

  Expanded _buildBody(BuildContext context) {
    return Expanded(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          primary: true,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: isClick || widget.reqType == "manualRequest"
            || widget.reqType == "priceRequest"
              ? buildMakeRequestForm(widget.reqType)
              : _notFoundOrMakeRequest(context),
        ),
      ),
    );
  }

  Text _buildTitle(BuildContext context) {
    return Text(
      "Your Request",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: getProportionateScreenWidth(20),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  buildMakeRequestForm(String formName) {
    switch (formName) {
      // If vin fails
      case vinRequest:
        return const VinRequestForm();
      // If partNo fails
      case partNoRequest:
        return const PartNoRequestForm();
      // If vin succeed but doesn't get Parts
      case partRequest:
        return const PartRequestForm();
      // If crossRef fails
      case crossRefRequest || priceRequest:
        return const CrossRefRequestForm();
      default:
        // If make/model/year/enginType fails
        return const ManualRequestForm();
    }
  }

  _notFoundOrMakeRequest(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text("Didn't find your search?"),
          ),

          /// Or Section
          orSeparator(lineColor: color, textColor: color, text: "You can"),
          const SizedBox(height: 10),
          buildElevatedBtn(
            context,
            label: "Make Request",
            // borderColor: Colors.transparent,
            onPress: () => setState(() => isClick = true),
          ),
        ],
      ),
    );
  }
}
