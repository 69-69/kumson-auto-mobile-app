import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';

class CrossRefRequestForm extends StatefulWidget {
  const CrossRefRequestForm({super.key});

  @override
  State<CrossRefRequestForm> createState() => _CrossRefRequestFormState();
}

class _CrossRefRequestFormState extends State<CrossRefRequestForm> {
  final _formKey = GlobalKey<FormState>();

  void _processData() {
    // Process your data and upload to server
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: _formKey, child: _buildBody(context));
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
      child: Column(
        children: [
          _buildVinFormField(context),
          _gaps(),
          _buildPartFormField(context),
          _gaps(),
          _buildNameFormField(context),
          _gaps(),
          _buildEmailFormField(context),
          _gaps(),
          _buildPhoneFormField(context),
          _gaps(),
          SizedBox(
            width: SizeConfig.screenWidth,
            child: buildOutlinedBtn(
              context,
              onPress: () {_processData();},
              label: "Submit",
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _gaps() => SizedBox(height: getProportionateScreenHeight(7));

  TextFormField _buildVinFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "VIN",
        // errorText: snapshot.hasError ? snapshot.error.toString() : "",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),

        alignLabelWithHint: true,
        /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),*/
      ),
    );
  }

  TextFormField _buildNameFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Name",
        // errorText: snapshot.hasError ? snapshot.error.toString() : "",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),

        alignLabelWithHint: true,
        /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),*/
      ),
    );
  }

  TextFormField _buildEmailFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Email",
        // errorText: snapshot.hasError ? snapshot.error.toString() : "",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),

        alignLabelWithHint: true,
        /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),*/
      ),
    );
  }

  TextFormField _buildPhoneFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Phone Number",
        // errorText: snapshot.hasError ? snapshot.error.toString() : "",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),

        alignLabelWithHint: true,
        /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),*/
      ),
    );
  }

  TextFormField _buildPartFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Part Name",
        // errorText: snapshot.hasError ? snapshot.error.toString() : "",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),

        alignLabelWithHint: true,
        /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),*/
      ),
    );
  }
}
