import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_stepper.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/items_dropdown.dart';
import 'package:automasters/core/util/size_config.dart';

class PartRequestForm extends StatefulWidget {
  const PartRequestForm({super.key});

  @override
  State<PartRequestForm> createState() => _PartRequestFormState();
}

class _PartRequestFormState extends State<PartRequestForm> {
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
        titles: const ['Part', 'Personal'],
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
         /* _gaps(),
          SizedBox(
            width: SizeConfig.screenWidth,
            child: buildOutlinedBtn(
              context,
              onPress: () {_processData();},
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
}
