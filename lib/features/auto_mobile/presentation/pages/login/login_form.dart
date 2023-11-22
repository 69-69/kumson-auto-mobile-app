import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/login/login_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildText(context),
            const Divider(thickness: 1),
            SizedBox(height: getProportionateScreenHeight(20)),
            _EmailInput(),
            SizedBox(height: getProportionateScreenHeight(7)),
            _PasswordInput(),
            SizedBox(height: getProportionateScreenHeight(7)),
            _LoginButton(),
          ],
        ),
      ),
    );
  }

  Text buildText(BuildContext context) {
    return Text(
      "LogIn",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: getProportionateScreenWidth(18),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) => _buildEmailFormField(context, state),
    );
  }

  TextFormField _buildEmailFormField(BuildContext context, LoginState state) {
    return TextFormField(
      key: const Key('loginForm_usernameInput_textField'),
      keyboardType: TextInputType.emailAddress,
      onChanged: (username) =>
          context.read<LoginBloc>().add(LoginUsernameChanged(username)),
      decoration: InputDecoration(
        filled: true,
        hintText: "Enter Email",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        alignLabelWithHint: true,
        errorText:
            state.email.displayError != null ? 'invalid username' : null,

        /*border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),*/
      ),
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _secureText = true;
  TextEditingController emailController = TextEditingController();

  // Show . hide password
  void showHide() => setState(() => _secureText = !_secureText);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) => _buildPasswordFormField(context, state),
    );
  }

  TextFormField _buildPasswordFormField(
      BuildContext context, LoginState state) {
    return TextFormField(
      key: const Key('loginForm_passwordInput_textField'),
      obscureText: _secureText,
      maxLength: 10,
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: () => FocusScope.of(context).requestFocus(FocusNode()),
      validator: (v) => v!.length < 4 ? "Enter valid password" : null,
      onChanged: (password) =>
          context.read<LoginBloc>().add(LoginPasswordChanged(password)),
      decoration: InputDecoration(
        filled: true,
        hintText: "Enter Password",
        errorText:
            state.password.displayError != null ? 'invalid password' : null,
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
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? showCircularProgress(width: 15, height: 15)
            : buildOutlinedButton(
                context,
                'Login',
                key: const Key('loginForm_continue_raisedButton'),
                onPress: state.isValid
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                        pageNavigator(context, routeName: autoHomeRoute);
                      }
                    : null,
              );
      },
    );
  }

  buildOutlinedButton(
    BuildContext context,
    String label, {
    Key? key,
    required void Function()? onPress,
    MaterialStatesController? buttonController,
  }) =>
      SizedBox(
        width: SizeConfig.screenWidth,
        child: buildElevatedBtn(
          key: key,
          context,
          label: label,
          onPress: onPress,
          buttonController: buttonController,
        ),
      );
}
