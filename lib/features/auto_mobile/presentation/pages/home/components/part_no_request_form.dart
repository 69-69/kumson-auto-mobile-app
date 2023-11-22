import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_stepper.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_pem.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/search_history_service.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/make_model_dropdown.dart';

class PartNoRequestForm extends StatefulWidget {
  const PartNoRequestForm({super.key});

  @override
  State<PartNoRequestForm> createState() => _PartNoRequestFormState();
}

class _PartNoRequestFormState extends State<PartNoRequestForm> {
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController productController = TextEditingController();
  MaterialStatesController? buttonController;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};
  String productName = "";
  String makeRef = "";

  void _processData() {
    makeController.clear();
    modelController.clear();
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
        stepperContents: [
          _partInfo(context),
          _personalInfo(context),
        ],
        onSubmit: (int currentStepper) {
          debugPrint("submitted $currentStepper");
          _processData();
        },
      ),
    );
  }

  Padding _partInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
      child: Column(
        children: [
          _buildPartNoFormField(context),
          _gaps(),
          _buildMakeFormField(),
          _gaps(),
          _buildModelFormField(),
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

  IconButton _swapFieldsButton({bool isProduct = false}) => IconButton(
    icon: const Icon(Icons.swap_horiz),
    onPressed: () {
      setState(() {
        isProduct ? (productName = "") : (makeRef = "");
      });
    },
  );

  TextFormField _buildPartNoFormField(BuildContext context) {
    String readOnlyPartNo =
        SearchHistoryDB().getProductStatus(key: readOnlyPartNoKey);
    Color color = Theme.of(context).colorScheme.primary;
    const textStyle = TextStyle(color: Colors.white, fontSize: 12);

    return readOnlyPartNo.isNotEmpty
        ? readOnlyPartNoField(textStyle, readOnlyPartNo, color)
        : partNoField(context);
  }

  TextFormField readOnlyPartNoField(
      TextStyle textStyle, readOnlyVin, Color color) {
    return TextFormField(
      readOnly: true,
      style: textStyle,
      controller: TextEditingController(text: readOnlyVin),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: color,
        prefix: Text("Part No.: ",
            style: textStyle.copyWith(fontWeight: FontWeight.bold)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
        // errorText: snapshot.hasError ? snapshot.error.toString() : "",
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      ),
    );
  }

  _buildMakeFormField() {
    return makeRef.toLowerCase() != "others"
        ? buildMakesDropdown(
      controller: makeController,
      onChanged: (v) {
        // Check if 'v' is a String or Model Object
        var ref = (v.runtimeType == String) ? v : v.makeRef;
        setState(() => makeRef = ref);

        debugPrint("make-1 $ref");
      },
    )
        : _otherMakeFormField(context);
  }

  _buildModelFormField() {
    return makeRef.toLowerCase() != "others"
        ? buildModelsDropdown(
      makeRef,
      controller: modelController,
      onChanged: (v) {
        debugPrint("model-1 $v");
      },
    )
        : _otherModelFormField(context);
  }

  _buildProductNameFormField() {
    return productName.toLowerCase() != "others"
        ? buildProductsDropdown(
      controller: productController,
      onChanged: (v) {
        // Check if 'v' is a String or Model Object
        var name = (v.runtimeType == String) ? v : v.locPartName;
        setState(() => productName = name);

        debugPrint("product-1 $name");
      },
    )
        : _otherProductNameFormField(context);
  }

  TextFormField _otherMakeFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Others: Specify",
        labelText: "Car Make",
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

  TextFormField _otherModelFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Others: Specify",
        labelText: "Car Model",
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
        suffixIcon: _swapFieldsButton(isProduct: true),
        alignLabelWithHint: true,
        /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),*/
      ),
    );
  }

  TextFormField partNoField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Part No.",
        labelText: "Part No.",
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
      keyboardType: TextInputType.phone,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Phone Number",
        labelText: "Phone Number",
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
