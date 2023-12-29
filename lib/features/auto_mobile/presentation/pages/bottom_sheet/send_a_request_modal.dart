import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/by_cross_ref/cross_ref_request_form.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/part_no_request_form.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/vin_request_form.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/part/part_request_form.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/home/components/manual_request_form.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/build_modal.dart';

/// Show Inline request Button: [InlineRequestButton]
class InlineRequestButton extends StatelessWidget {
  final String reqType;
  final String? notFoundMsg;
  final String? orMsg;

  const InlineRequestButton({
    super.key,
    required this.reqType,
    this.notFoundMsg,
    this.orMsg,
  });

  @override
  Widget build(BuildContext context) {
    return showInlineRequestButton(context);
  }

  showInlineRequestButton(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return FittedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(notFoundMsg ?? "Product not found!"),
          ),

          /// Or Section
          orSeparator(
              lineColor: color, textColor: color, text: orMsg ?? " You can "),
          showMakeRequestButton(
            context,
            reqType,
            borderColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

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
          label: "Send Request",
          borderColor: borderColor,
          onPress: () => showRequestModal(context, reqType),
        ),
      );
}

/// Show Modal-dialog automatically [showRequestModal]
showRequestModal(BuildContext context, String reqType) =>
    buildModal(context, SendRequestModal(reqType: reqType));

class SendRequestModal extends StatefulWidget {
  final String reqType;

  const SendRequestModal({super.key, required this.reqType});

  @override
  State<SendRequestModal> createState() => _SendRequestModalState();
}

class _SendRequestModalState extends State<SendRequestModal> {
  bool isClick = false;

  @override
  Widget build(BuildContext context) {
    // Call SizeConfig on your starting screen
    SizeConfig().init(context);
    // double appBarHeight = AppBar().preferredSize.height;

    /*return LayoutBuilder(
      builder: (_, constraints) {
        final height = (constraints.maxHeight) - appBarHeight;

        return SizedBox(height: height, child: _buildBody(context));
      },
    );*/

    return IntrinsicHeight(
      child: _buildBody(context),
    );
  }

  Column _buildBody(BuildContext context) {
    final mostReq = [priceRequest, manualRequest, crossRefRequest, partRequest];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isClick) ...{
          _buildTitle(context),
          const Divider(thickness: 1),
        },
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              primary: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: isClick || mostReq.any((e) => e.contains(widget.reqType))
                  ? buildMakeRequestForm(widget.reqType)
                  : _notFoundOrMakeRequest(context),
            ),
          ),
        ),
      ],
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
      // If crossRef / vendor fails
      case crossRefRequest || priceRequest:
        return const CrossRefRequestForm();
      default:
        // If make/model/year/enginType fails
        return const ManualRequestForm();
    }
  }

  //TODO: _notFoundOrMakeRequest
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
            label: "Send Request",
            // borderColor: Colors.transparent,
            onPress: () => setState(() => isClick = true),
          ),
        ],
      ),
    );
  }
}
