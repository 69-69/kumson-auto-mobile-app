import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/data/models/make.dart';
import 'package:automasters/features/auto_mobile/data/repositories/home_repository_impl.dart';
import 'package:automasters/features/auto_mobile/data/models/model.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/make_model_dropdown.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';

class MakeModelRequestForm extends StatefulWidget {
  const MakeModelRequestForm({super.key});

  @override
  State<MakeModelRequestForm> createState() => _MakeModelRequestFormState();
}

class _MakeModelRequestFormState extends State<MakeModelRequestForm> {
  TextEditingController? makeController, modelController;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData = {};

  void _processData() {
    makeController?.clear();
    modelController?.clear();
    // Process your data and upload to server
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: _formKey, child: _buildBody(context));
  }

  /*_ExampleFormState() {
    formData = {
      'City': 'Bangalore',
      'Country': 'INDIA',
    };
  }*/

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
      child: Column(
        children: [
          _buildMakeFormField(),
          _gaps(),
          _buildModelFormField(),
          _gaps(),
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
          _buildEngineCCFormField(context),
          _gaps(),
          _buildFuelTypeFormField(context),
          _gaps(),
          _buildBodyTypeFormField(context),
          _gaps(),
          _buildManuYearFormField(context),
          _gaps(),
          SizedBox(
            width: SizeConfig.screenWidth,
            child: buildOutlinedBtn(
              context,
              onPress: () {
                _processData();
              },
              label: "Submit",
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _gaps() => SizedBox(height: getProportionateScreenHeight(7));

  MakeModelDropdown _buildMakeFormField() {
    return MakeModelDropdown<MakeModel>(
      controller: makeController,
      value: formData['make'],
      hintText: 'Car Make',
      onChanged: (v) {
        debugPrint("make-1 $v");
      },
      setter: (dynamic newValue) {
        debugPrint("make-2 $newValue");
        formData['make'] = newValue;
      },
      asyncItems: (String query) async {
        final v =
            await _getData(query, "car_makes?page=0&size=300&sort=make,asc");
        List<MakeModel> matches = MakeModel.fromJsonList(v);

        filterResults<MakeModel>(matches, query);
        return matches;
        return MakeModel.fromJsonList(v);
      },
    );
  }

  MakeModelDropdown _buildModelFormField() {
    return MakeModelDropdown<Model>(
      controller: modelController,
      value: modelController?.text,
      hintText: 'Car Model',
      onChanged: (v) {
        debugPrint("model-1 $v");
      },
      asyncItems: (String query) async {
        final v =
            await _getData(query, "car_models?page=0&size=300&sort=model,desc");
        List<Model> matches = Model.fromJsonList(v);

        filterResults<Model>(matches, query);
        return matches;
      },
      setter: (dynamic newValue) {
        debugPrint("model-2 $newValue");
        formData['model'] = newValue;
      },
    );
  }

  Future _getData(String query, String endPoint) async {
    return HomeRepositoryImpl().getData(query, endPoint);
  }

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

  TextFormField _buildEngineCCFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Engine Capacity",
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

  TextFormField _buildFuelTypeFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Fuel Type",
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

  TextFormField _buildBodyTypeFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Body Type",
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

  TextFormField _buildManuYearFormField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      decoration: InputDecoration(
        filled: true,
        hintText: "Manufacturer Year",
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
