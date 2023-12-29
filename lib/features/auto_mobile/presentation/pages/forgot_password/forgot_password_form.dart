import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/login/remote/login_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key,this.onChanged});

  final Function(bool status)? onChanged;

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  bool isFailed = false;
  bool hideErrorMsg = false;

  @override
  Widget build(BuildContext context) {
    final tColor = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) {
        return LoginBloc(
          authRepository: RepositoryProvider.of<AuthRepositoryImpl>(context),
        );
      },
      child: _buildBody(context, tColor),);
  }

  Column _buildBody(BuildContext context, ColorScheme tColor) {
    return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      buildTitleHeader(context, "Forgot Password", 'Enter mobile number or email'),
      const Divider(thickness: 1),
      if (isFailed && !hideErrorMsg) ...{
        buildChip(
          'Incorrect mobile number or email!',
          onDelete: () => setState(() => hideErrorMsg = true),
        ),
        const Divider(thickness: 0.3, height: 0.2),
      },
      SizedBox(height: getProportionateScreenHeight(20)),
      _EmailOrPhoneInput(),
      SizedBox(height: getProportionateScreenHeight(7)),
      _LoginButton(),

      /// Or Section
      orSeparator(
        lineColor: tColor.primary,
        textColor: tColor.primary,
      ),

      /// Login to an account
      buildOutlinedBtn(
        context,
        label: 'Login to Account',
        onPress: ()=> setState(() => widget.onChanged!(false)),
        borderColor: Colors.transparent,
      ),
    ],
  );
  }
}

class _EmailOrPhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.emailOrPhone != current.emailOrPhone,
      builder: (context, state) => _buildEmailFormField(context, state),
    );
  }

  TextFormField _buildEmailFormField(BuildContext context, LoginState state) {
    return TextFormField(
      key: const Key('ForgotPasswordForm_emailInput_textField'),
      keyboardType: TextInputType.text,
      onChanged: (input) =>
          context.read<LoginBloc>().add(LoginEmailOrPhoneChanged(input)),
      decoration: InputDecoration(
        filled: true,
        labelText: "Email or Mobile number",
        hintText: "Enter Email or Mobile number",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        alignLabelWithHint: true,
        errorText: state.emailOrPhone.displayError != null ? 'Invalid email or mobile number' : null,

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
      key: const Key('ForgotPasswordForm_passwordInput_textField'),
      obscureText: _secureText,
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: () => FocusScope.of(context).requestFocus(FocusNode()),
      // validator: (v) => v!.length < 4 ? "Enter valid password" : null,
      onChanged: (password) =>
          context.read<LoginBloc>().add(LoginPasswordChanged(password)),
      decoration: InputDecoration(
        filled: true,
        hintText: "Enter Password",
        labelText: "Password",
        errorText:
            state.password.displayError != null ? 'Invalid password' : null,
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
                'Submit',
                key: const Key('ForgotPasswordForm_continue_raisedButton'),
                onPress: state.isValid
                    ? () => context
                        .read<LoginBloc>()
                        .add(const LoginFormSubmitted())
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
