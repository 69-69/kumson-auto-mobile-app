import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';

class AuthModal extends StatefulWidget {
  final String authType;

  const AuthModal({super.key, required this.authType});

  @override
  State<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  bool _secureText = true;
  FocusNode inputFocus = FocusNode();
  bool textEditing = false;

  // Show . hide password
  void showHide() => setState(() => _secureText = !_secureText);

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
    bool isAuth = widget.authType.toLowerCase() == "log in";
    // double sheetHeight = textEditing ? 0.30 : 0;

    return IntrinsicHeight(
    /*return SizedBox(
      height: SizeConfig.screenHeight! *
          (isAuth ? (0.35 + sheetHeight) : (0.47 + sheetHeight)),*/
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          // primary: true,
          // scrollDirection: Axis.vertical,
          // padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight! / 4),
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(30),
            right: getProportionateScreenWidth(30),
            bottom: getProportionateScreenWidth(30), // MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            child: isAuth ? buildAuthForm(context) : buildRegForm(context),
          ),
        ),
      ),
    );
  }

  Column buildAuthForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText(context),
        const Divider(thickness: 1),
        SizedBox(height: getProportionateScreenHeight(20)),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          // onFieldSubmitted: bloc.onChangeEmail,
          // onChanged: bloc.onChangeEmail,
          onTap: () => setState(() => textEditing = true),
          decoration: InputDecoration(
            filled: true,
            hintText: "Enter Email",
            // errorText: snapshot.hasError ? snapshot.error.toString() : "",
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
            alignLabelWithHint: true,
            /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),*/
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(7)),
        TextFormField(
          obscureText: _secureText,
          maxLength: 10,
          keyboardType: TextInputType.emailAddress,
          // onFieldSubmitted: bloc.onChangeEmail,
          // onChanged: bloc.onChangeEmail,
          onTap: () => setState(() => textEditing = true),
          decoration: InputDecoration(
            filled: true,
            hintText: "Enter Password",
            // errorText: snapshot.hasError ? snapshot.error.toString() : "",
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),

            alignLabelWithHint: true,
            suffixIcon: IconButton(
              onPressed: showHide,
              icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility,
                  color: _secureText ? Colors.grey : const Color(0xFF757575)),
            ),
            /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),*/
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(7)),
        buildOutlinedButton(
          context,
          widget.authType,
          onPress: () {},
        ),
      ],
    );
  }

  Text buildText(BuildContext context) {
    return Text(
      widget.authType,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: getProportionateScreenWidth(20),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  buildOutlinedButton(BuildContext context, String label,
          {required void Function()? onPress}) =>
      SizedBox(
        width: SizeConfig.screenWidth,
        child: buildOutlinedBtn(
          context,
          label: label,
          onPress: onPress,
        ),
      );

  Column buildRegForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText(context),
        const Divider(thickness: 1),
        SizedBox(height: getProportionateScreenHeight(20)),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          // onFieldSubmitted: bloc.onChangeEmail,
          // onChanged: bloc.onChangeEmail,
          onTap: () => setState(() => textEditing = true),
          decoration: InputDecoration(
            filled: true,
            hintText: "Enter Email",
            // errorText: snapshot.hasError ? snapshot.error.toString() : "",
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),

            alignLabelWithHint: true,
            /*border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),*/
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(7)),
        TextFormField(
          keyboardType: TextInputType.phone,
          // onFieldSubmitted: bloc.onChangeEmail,
          // onChanged: bloc.onChangeEmail,
          onTap: () => setState(() => textEditing = true),
          decoration: InputDecoration(
            filled: true,
            hintText: "Enter Phone",
            // errorText: snapshot.hasError ? snapshot.error.toString() : "",
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),

            alignLabelWithHint: true,
            /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),*/
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(7)),
        TextFormField(
          obscureText: _secureText,
          keyboardType: TextInputType.text,
          maxLength: 10,
          // onFieldSubmitted: bloc.onChangeEmail,
          // onChanged: bloc.onChangeEmail,
          onTap: () => setState(() => textEditing = true),
          decoration: InputDecoration(
            filled: true,
            hintText: "Enter Password",
            // errorText: snapshot.hasError ? snapshot.error.toString() : "",
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),

            alignLabelWithHint: true,
            suffixIcon: IconButton(
              onPressed: showHide,
              icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility,
                  color: _secureText ? Colors.grey : const Color(0xFF757575)),
            ),
            /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),*/
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(7)),
        TextFormField(
          obscureText: _secureText,
          keyboardType: TextInputType.text,
          maxLength: 10,
          // onFieldSubmitted: bloc.onChangeEmail,
          // onChanged: bloc.onChangeEmail,
          onTap: () => setState(() => textEditing = true),
          decoration: InputDecoration(
            filled: true,
            hintText: "Confirm Password",
            // errorText: snapshot.hasError ? snapshot.error.toString() : "",
            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),

            alignLabelWithHint: true,
            suffixIcon: IconButton(
              onPressed: showHide,
              icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility,
                  color: _secureText ? Colors.grey : const Color(0xFF757575)),
            ),
            /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),*/
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(7)),
        buildOutlinedButton(
          context,
          widget.authType,
          onPress: () {},
        ),
      ],
    );
  }
}
