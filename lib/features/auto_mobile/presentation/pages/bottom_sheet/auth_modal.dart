import 'package:automasters/features/auto_mobile/domain/repositories/auth_repository.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/login/login_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthModal extends StatefulWidget {
  final String authType;

  const AuthModal({super.key, required this.authType});

  @override
  State<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  String username = "";
  String password = "";
  bool _secureText = true;
  bool textEditing = false;
  FocusNode inputFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  MaterialStatesController? buttonController;
  TextEditingController emailController = TextEditingController();

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
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
          child: _buildBody(isAuth, context),
        ),
      ),
    );
  }

  BlocProvider<LoginBloc> _buildBody(bool isAuth, BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LoginBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        );
      },
      child: isAuth ? const LoginForm() : buildRegForm(context),
      /*Form(
        key: formKey,
        child: isAuth ? buildAuthForm(context) : buildRegForm(context),
      ),*/
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

  Column buildAuthForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildText(context),
        const Divider(thickness: 1),
        SizedBox(height: getProportionateScreenHeight(20)),
        _buildEmailFormField(context),
        SizedBox(height: getProportionateScreenHeight(7)),
        _buildPasswordFormField(context),
        SizedBox(height: getProportionateScreenHeight(7)),
        buildOutlinedButton(
          context,
          widget.authType,
          onPress: () {},
          buttonController: buttonController,
        ),
      ],
    );
  }

  TextFormField _buildPasswordFormField(BuildContext context) {
    return TextFormField(
      obscureText: _secureText,
      maxLength: 10,
      keyboardType: TextInputType.visiblePassword,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      onTap: () => setState(() => textEditing = true),
      onChanged: (v) => setState(() => password = v),
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(FocusNode());
        buttonController?.update(MaterialState.pressed, false);
      },
      validator: (v) => v!.length < 4 ? "Enter valid password" : null,
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
    );
  }

  TextFormField _buildEmailFormField(BuildContext context) {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      // onFieldSubmitted: bloc.onChangeEmail,
      // onChanged: bloc.onChangeEmail,
      onTap: () => setState(() => textEditing = true),
      onChanged: (v) => setState(() => username = v),
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
    );
  }

  buildOutlinedButton(
    BuildContext context,
    String label, {
    required void Function()? onPress,
    MaterialStatesController? buttonController,
  }) =>
      SizedBox(
        width: SizeConfig.screenWidth,
        child: buildElevatedBtn(
          context,
          label: label,
          onPress: onPress,
          buttonController: buttonController,
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
