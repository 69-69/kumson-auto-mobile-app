import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';
import '../utils/size_config.dart';

class MakeARequestModal extends StatefulWidget {
  final String reqType;

  const MakeARequestModal({super.key, required this.reqType});

  @override
  State<MakeARequestModal> createState() => _MakeARequestModalState();
  }

  class _MakeARequestModalState extends State<MakeARequestModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);

    return Container(
      height: SizeConfig.screenHeight! * 0.5,
      padding:
      EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(60)),
      child: SingleChildScrollView(
        primary: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Form(
          child: buildAuthForm(context),
        ),
      ),
    );
  }

  Column buildAuthForm(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.reqType.capitalize(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: getProportionateScreenWidth(20),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Divider(thickness: 1),
        SizedBox(height: getProportionateScreenHeight(20)),
        TextFormField(
          keyboardType: TextInputType.text,
          // onFieldSubmitted: bloc.onChangeEmail,
          // onChanged: bloc.onChangeEmail,
          decoration: InputDecoration(
            filled: true,
            hintText: "Car Make",
            // errorText: snapshot.hasError ? snapshot.error.toString() : "",
            fillColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.04),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 2.0, horizontal: 10.0),

            alignLabelWithHint: true,
            /*border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),*/
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(7)),
        TextFormField(
          keyboardType: TextInputType.text,
          // onFieldSubmitted: bloc.onChangeEmail,
          // onChanged: bloc.onChangeEmail,
          decoration: InputDecoration(
            filled: true,
            hintText: "VIN",
            // errorText: snapshot.hasError ? snapshot.error.toString() : "",
            fillColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.04),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 2.0, horizontal: 10.0),

            alignLabelWithHint: true,
            /*border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),*/
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(7)),
        SizedBox(
          width: SizeConfig.screenWidth,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                  width: 1.0,
                  color: Theme.of(context).colorScheme.primary),
            ),
            child: const Text("Submit"),
          ),
        ),
      ],
    );
  }
}
