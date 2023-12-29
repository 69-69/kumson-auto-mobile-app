import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/forgot_password/forgot_password_form.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/login/remote/login_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isFailed = false;
  bool hideErrorMsg = false;
  bool _emailOrPhone = false;
  bool forgotPassword = false;

  @override
  Widget build(BuildContext context) {
    final tColor = Theme.of(context).colorScheme;

    return forgotPassword
        ? ForgotPasswordForm(onChanged: (bool value) {
            setState(() => forgotPassword = value);
          })
        : BlocProvider(
            create: (context) {
              return LoginBloc(
                authRepository: RepositoryProvider.of<AuthRepositoryImpl>(context),
              );
            },
            child: _buildBody(context, tColor),
          );
  }

  BlocListener<LoginBloc, LoginState> _buildBody(
      BuildContext context, ColorScheme tColor) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (_, state) {
        if (state.status.isFailure) {
          setState(() {
            isFailed = true;
            hideErrorMsg = false;
          });
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTitleHeader(context, "Log In", 'One Time Login'),
            const Divider(thickness: 1),
            if (isFailed && !hideErrorMsg) ...{
              buildChip(
                'Incorrect email, mobile number or password!',
                onDelete: () => setState(() => hideErrorMsg = true),
              ),
              const Divider(thickness: 0.3, height: 0.2),
            },
            SizedBox(height: getProportionateScreenHeight(20)),
            _emailOrPhone ? const _PhoneInput() : const _EmailInput(),
            SizedBox(height: getProportionateScreenHeight(7)),
            _PasswordInput(),
            SizedBox(height: getProportionateScreenHeight(7)),
            _LoginButton(),

            /// Or Section
            orSeparator(
              lineColor: tColor.primary,
              textColor: tColor.primary,
            ),

            /// Don't have an account
            TextButton(
              child: Text(
                  'Login with ${_emailOrPhone ? 'Email' : 'Mobile number'}?'),
              onPressed: () => setState(() => _emailOrPhone = !_emailOrPhone),
            ),
            const Divider(height: 0.1),

            /// Don't have an account
            buildOutlinedBtn(
              context,
              label: 'Forgot Password?',
              onPress: () => setState(() => forgotPassword = true),
              borderColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.emailOrPhone != current.emailOrPhone,
      builder: (context, state) => _buildEmailFormField(context, state),
    );
  }

  // Email Input
  TextFormField _buildEmailFormField(BuildContext context, LoginState state) {
    return TextFormField(
      key: const Key('loginForm_emailInput_textField'),
      keyboardType: TextInputType.emailAddress,
      onChanged: (input) =>
          context.read<LoginBloc>().add(LoginEmailOrPhoneChanged(input)),
      decoration: InputDecoration(
        filled: true,
        labelText: "Email address",
        hintText: "Enter Email address",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        alignLabelWithHint: true,
        errorText:
            state.emailOrPhone.displayError != null ? 'Invalid email' : null,

        /*border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),*/
      ),
    );
  }
}

class _PhoneInput extends StatelessWidget {
  const _PhoneInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.emailOrPhone != current.emailOrPhone,
      builder: (context, state) => _phoneNumberInput(context, state),
    );
  }

  // Phone Input
  TextFormField _phoneNumberInput(BuildContext context, LoginState state) {
    final CountryDetails details = CountryCodes.detailsForLocale();
    final countryCode = details.dialCode!.length;

    return TextFormField(
      key: const Key('loginForm_phoneNumberInput_textField'),
      keyboardType: TextInputType.phone,
      inputFormatters: [DialCodeFormatter()],
      onChanged: (phoneNumber) {
        // Remove leading zeros, if any
        String phone = stripLeadingZero(phoneNumber);

        String phoneWithCountryCode =
            stripZeroFromPhoneAreaCode(phone, countryCode);

        // Remove leading '+', if any
        String number = stripLeadingPlus(phoneWithCountryCode);

        context.read<LoginBloc>().add(LoginEmailOrPhoneChanged(number));
      },
      decoration: InputDecoration(
        filled: true,
        hintText: "Enter Mobile number",
        labelText: "Mobile number",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        alignLabelWithHint: true,
        errorText: state.emailOrPhone.displayError != null
            ? 'Invalid Mobile number'
            : null,
      ),
    );
  }
}

// Email Or Phone Input
class _EmailOrPhoneInput extends StatefulWidget {
  @override
  State<_EmailOrPhoneInput> createState() => _EmailOrPhoneInputState();
}

class _EmailOrPhoneInputState extends State<_EmailOrPhoneInput> {
  final GlobalKey _toolTipKey = GlobalKey();
  bool _emailOrPhone = false;

  @override
  void initState() {
    // This will trigger the Tooltip after the widget has been built

    Future.delayed(const Duration(milliseconds: 2), () {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showTooltip());
    });

    super.initState();
  }

  void _showTooltip() {
    final dynamic tooltip = _toolTipKey.currentState;
    tooltip?.ensureTooltipVisible();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.emailOrPhone != current.emailOrPhone,
      builder: (context, state) => _emailOrPhone
          ? _phoneNumberInput(context, state)
          : _buildEmailFormField(context, state),
    );
  }

  // Email Input
  TextFormField _buildEmailFormField(BuildContext context, LoginState state) {
    return TextFormField(
      key: const Key('loginForm_emailInput_textField'),
      keyboardType: TextInputType.text,
      onChanged: (input) =>
          context.read<LoginBloc>().add(LoginEmailOrPhoneChanged(input)),
      decoration: InputDecoration(
        filled: true,
        labelText: "Email address",
        hintText: "Enter Email address",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        alignLabelWithHint: true,
        suffixIcon: _swapFieldsButton(),
        errorText:
            state.emailOrPhone.displayError != null ? 'Invalid email' : null,

        /*border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),*/
      ),
    );
  }

  // Phone Input
  TextFormField _phoneNumberInput(BuildContext context, LoginState state) {
    final CountryDetails details = CountryCodes.detailsForLocale();
    final countryCode = details.dialCode!.length;

    return TextFormField(
      key: const Key('loginForm_phoneNumberInput_textField'),
      keyboardType: TextInputType.phone,
      inputFormatters: [DialCodeFormatter()],
      onChanged: (phoneNumber) {
        final phone = stripZeroFromPhoneAreaCode(phoneNumber, countryCode);

        context.read<LoginBloc>().add(LoginEmailOrPhoneChanged(phone));
      },
      decoration: InputDecoration(
        filled: true,
        hintText: "Mobile number",
        labelText: "Mobile number",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        alignLabelWithHint: true,
        suffixIcon: _swapFieldsButton(),
        errorText: state.emailOrPhone.displayError != null
            ? 'Invalid Mobile number'
            : null,
      ),
    );
  }

  _swapFieldsButton() => SizedBox(
        width: 20,
        child: Tooltip(
          key: _toolTipKey,
          preferBelow: false,
          waitDuration: const Duration(milliseconds: 2),
          message: 'Use Mobile number instead',
          child: IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              setState(() => _emailOrPhone = !_emailOrPhone);
            },
          ),
        ),
      );
}

// Password Input
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

// Button
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
