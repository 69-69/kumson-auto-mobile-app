import 'package:automasters/features/auto_mobile/presentation/widgets/custom_stepper.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/items_dropdown.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_service.dart';

class CrossRefRequestForm extends StatefulWidget {
  const CrossRefRequestForm({super.key});

  @override
  State<CrossRefRequestForm> createState() => _CrossRefRequestFormState();
}

class _CrossRefRequestFormState extends State<CrossRefRequestForm> {
  TextEditingController productController = TextEditingController();
  ProductsDropdown productsDropdown = ProductsDropdown();
  final _formKey = GlobalKey<FormState>();
  String _productName = "";

  void _processData() {
    productController.clear();
    // Process your data and upload to server
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
    // return Form(key: _formKey, child: _buildBody(context));
  }

  Form _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: CustomStepper(
        titles: const ['Vehicle', 'Personal'],
        subTitle: const ['Helps data collection', 'Helps to contact you'],
        contents: [
          _vehicleInfo(context),
          _personalInfo(context),
        ],
        onSubmit: (int currentStepper) {
          debugPrint("submitted $currentStepper");
          _processData();
        },
      ),
    );
  }

  Padding _vehicleInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
      child: Column(
        children: [
          _buildVinFormField(context),
          _gaps(),
          _buildProductNameFormField(),
        ],
      ),
    );
  }

  Padding _personalInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
      child: Column(
        children: [
          _buildNameFormField(context),
          _gaps(),
          _buildEmailFormField(context),
          _gaps(),
          _buildPhoneFormField(context),
          /*_gaps(),
          SizedBox(
            width: SizeConfig.screenWidth,
            child: buildOutlinedBtn(
              context,
              onPress: () {
                _processData();
              },
              label: "Submit",
            ),
          ),*/
        ],
      ),
    );
  }

  SizedBox _gaps() => SizedBox(height: getProportionateScreenHeight(7));

  IconButton _swapFieldsButton() => IconButton(
    icon: const Icon(Icons.swap_horiz),
    onPressed: () {
      setState(() => _productName = "");
    },
  );

  TextFormField _buildVinFormField(BuildContext context) {
    String readOnlyVin = AppLocalService().getProductStatus(key: sendRequestVinCacheKey);
    Color color = Theme.of(context).colorScheme.primary;
    const textStyle = TextStyle(color: Colors.white, fontSize: 12);

    return readOnlyVin.isNotEmpty
        ? _readOnlyVinField(textStyle, readOnlyVin, color)
        : _vinField(context);
  }

  TextFormField _readOnlyVinField(
      TextStyle textStyle, String readOnlyVin, Color color) {
    return TextFormField(
      readOnly: true,
      style: textStyle,
      controller: TextEditingController(text: readOnlyVin),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: color,
        prefix: Text("VIN: ",
            style: textStyle.copyWith(fontWeight: FontWeight.bold)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
        // errorText: snapshot.hasError ? snapshot.error.toString() : "",
        contentPadding:
        const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      ),
    );
  }

  TextFormField _vinField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "VIN",
        labelText: "VIN",
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
        labelText: "Name",
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
        labelText: "Email",
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
        maxLength: 16,
        keyboardType: TextInputType.phone,
        inputFormatters: [DialCodeFormatter()],
      decoration: InputDecoration(
        filled: true,
        hintText: "Mobile Number",
        labelText: "Mobile Number",
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

  _buildProductNameFormField() {
    return _productName.toLowerCase() != "others"
        ? productsDropdown.buildProductsDropdown(
      controller: productController,
      onChanged: (v) {
        // Check if 'v' is a String or Model Object
        var name = (v.runtimeType == String) ? v : v.locPartName;
        setState(() => _productName = name);

        debugPrint("product-1 $name");
      },
    )
        : _otherProductNameFormField(context);
  }

  TextFormField _otherProductNameFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Others: specify",
        labelText: "Product Name",
        // errorText: snapshot.hasError ? snapshot.error.toString() : "",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        suffixIcon: _swapFieldsButton(),
        alignLabelWithHint: true,
        /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),*/
      ),
    );
  }

}
