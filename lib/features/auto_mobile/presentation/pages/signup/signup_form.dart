import 'package:automasters/core/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/core/constants/user_role.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:country_codes/country_codes.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/signup/remote/signup_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/otp/otp_form.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/auth/remote/auth_bloc.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';
import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/custom_stepper.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool isFailed = false;
  bool hideErrorMsg = false;
  bool isSuccessful = false;
  String phoneNumber = '';
  final _formFieldKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = context.select((AuthBloc bloc) => bloc.state);
    final activeOTP = authState.activeOTP;
    final activeSignup = authState.activeSignup;

    return activeSignup.isNotEmpty || activeOTP.isNotEmpty
        ? OTPForm(phoneNumber: activeSignup.phoneNumber)
        : BlocProvider(
            create: (context) {
              return SignupBloc(
                authRepository:
                    RepositoryProvider.of<AuthRepositoryImpl>(context),
              );
            },
            child: _buildBody(context),
          );
  }

  BlocListener<SignupBloc, SignupState> _buildBody(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (_, state) {
        if (state.status.isSuccess) {
          setState(() => isSuccessful = true);
        }
        if (state.status.isFailure) {
          setState(() {
            isFailed = true;
            hideErrorMsg = false;
          });
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: _signupForm(),
      ),
    );
  }

  _signupForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: buildTitleHeader(context, "Sign Up", "It's quick and easy."),
        ),
        const Divider(thickness: 1),
        if (isFailed && !hideErrorMsg) ...{
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: buildChip(
              'Your Email or Mobile number is already in use...try again!',
              onDelete: () => setState(() => hideErrorMsg = true),
            ),
          ),
          const Divider(thickness: 0.3, height: 0.2),
        },
        CustomStepper(
          elevation: 0.0,
          doneLabel: 'Sign Up',
          formFieldKey: _formFieldKey,
          titles: const ['Basic', 'Account'],
          subTitle: const ['Helps in recovery', 'Secure your data'],
          contents: [
            _signupStepOne(context),
            _signupStepTwo(context),
          ],
          doneBtn: _SignupButton(),
          onSubmit: (int i) {},
        ),
      ],
    );
  }

  /// [Form] Widget is used to help validate the STEPPER WIDGET [_signupStepOne]
  _signupStepOne(BuildContext context) {
    return Form(
      key: _formFieldKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NameInput(),
          SizedBox(height: getProportionateScreenHeight(7)),
          _PhoneNumberInput(onChanged: (value) {
            setState(() => phoneNumber = value);
          }),
          SizedBox(height: getProportionateScreenHeight(7)),
          _RoleInput(),
        ],
      ),
    );
  }

  _signupStepTwo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _EmailInput(),
        SizedBox(height: getProportionateScreenHeight(7)),
        _PasswordInput(),
        SizedBox(height: getProportionateScreenHeight(7)),
        _ConfirmPasswordInput(),
      ],
    );
  }
}

// First & Last Name Input
class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: BlocBuilder<SignupBloc, SignupState>(
            buildWhen: (previous, current) =>
                previous.firstName != current.firstName,
            builder: (context, state) => SizedBox(
              width: SizeConfig.screenWidth! / 2,
              child: _firstNameInput(context, state),
            ),
          ),
        ),
        SizedBox(width: getProportionateScreenHeight(20)),
        Expanded(
          child: BlocBuilder<SignupBloc, SignupState>(
            buildWhen: (previous, current) =>
                previous.lastName != current.lastName,
            builder: (context, state) => SizedBox(
              width: SizeConfig.screenWidth! / 2,
              child: _lastNameInput(context, state),
            ),
          ),
        ),
      ],
    );
  }

  TextFormField _firstNameInput(BuildContext context, SignupState state) {
    return _nameFormField(
      'SignupForm_firstNameInput_textField',
      label: 'First',
      context: context,
      hasError: state.firstName.displayError != null,
      onChanged: (firstName) =>
          context.read<SignupBloc>().add(SignupFirstNameChanged(firstName)),
    );
  }

  TextFormField _lastNameInput(BuildContext context, SignupState state) {
    return _nameFormField(
      'SignupForm_lastNameInput_textField',
      label: 'last',
      context: context,
      hasError: state.lastName.displayError != null,
      onChanged: (lastName) =>
          context.read<SignupBloc>().add(SignupLastNameChanged(lastName)),
    );
  }

  TextFormField _nameFormField(
    String key, {
    String label = '',
    bool hasError = false,
    Function(String)? onChanged,
    required BuildContext context,
  }) {
    return TextFormField(
      key: Key(key),
      keyboardType: TextInputType.name,
      // onChanged: (name) => onChanged(name),

      decoration: InputDecoration(
        filled: true,
        hintText: "$label name",
        labelText: "$label name",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        alignLabelWithHint: true,
        errorText: hasError ? 'Valid $label name required' : null,
      ),
      validator: (v) =>
          v == null || v.isEmpty ? 'Valid $label name required' : null,
    );
  }
}

// Phone Input
class _PhoneNumberInput extends StatelessWidget {
  const _PhoneNumberInput({this.onChanged});

  final Function(String text)? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) => _phoneNumberInput(context, state),
    );
  }

  TextFormField _phoneNumberInput(BuildContext context, SignupState state) {
    final CountryDetails details = CountryCodes.detailsForLocale();
    final countryCode = details.dialCode!.length;

    return TextFormField(
      key: const Key('SignupForm_phoneNumberInput_textField'),
      keyboardType: TextInputType.phone,
      inputFormatters: [DialCodeFormatter()],
      onChanged: (phoneNumber) {
        // Remove leading zeros, if any
        String phone = stripLeadingZero(phoneNumber);

        String phoneWithCountryCode =
            stripZeroFromPhoneAreaCode(phone, countryCode);

        // Remove leading '+', if any
        String number = stripLeadingPlus(phoneWithCountryCode);

        context.read<SignupBloc>().add(SignupPhoneChanged(number));
        onChanged!(phone);
      },
      decoration: InputDecoration(
        filled: true,
        hintText: "Mobile number",
        labelText: "Mobile number",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        alignLabelWithHint: true,
        errorText: state.phoneNumber.displayError != null
            ? 'Invalid Mobile number'
            : null,
      ),
      validator: (v) =>
          v != null && v.isNotEmpty ? null : 'Valid number required',
    );
  }
}

// Role Input
class _RoleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.userRole != current.userRole,
      builder: (context, state) => _roleInput(context, state),
    );
  }

  _roleInput(BuildContext context, SignupState state) {
    // List<String> list = UserRole.values.map((e) => e.name).toList();

    return FittedBox(
      child: DropdownMenu<UserRole>(
        key: const Key('SignupForm_roleInput_textField'),
        // initialSelection: UserRole.unknown,
        hintText: "Your Role",
        requestFocusOnTap: true,
        width: SizeConfig.screenWidth! * 0.88,
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
          alignLabelWithHint: true,
        ),
        errorText:
            state.userRole.displayError != null ? 'Select your role' : null,
        onSelected: (UserRole? role) =>
            context.read<SignupBloc>().add(SignupUserRoleChanged(role!.name)),
        dropdownMenuEntries:
            UserRole.values.map<DropdownMenuEntry<UserRole>>((UserRole role) {
          return DropdownMenuEntry<UserRole>(
            value: role,
            label: role.name.capitalize(),
          );
        }).toList(),
      ),
    );
  }
}

// Email Input
class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) => _buildEmailFormField(context, state),
    );
  }

  TextFormField _buildEmailFormField(BuildContext context, SignupState state) {
    return TextFormField(
      key: const Key('SignupForm_emailInput_textField'),
      keyboardType: TextInputType.emailAddress,
      onChanged: (email) =>
          context.read<SignupBloc>().add(SignupEmailChanged(email)),
      decoration: InputDecoration(
        filled: true,
        hintText: "Email",
        labelText: "Email",
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        alignLabelWithHint: true,
        errorText: state.email.displayError != null ? 'Invalid email' : null,
      ),
    );
  }
}

// Password Input
class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _secureText = true;

  // Show . hide password
  void showHide() => setState(() => _secureText = !_secureText);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) => _buildPasswordInput(context, state),
    );
  }

  TextFormField _buildPasswordInput(BuildContext context, SignupState state) {
    return TextFormField(
      key: const Key('SignupForm_passwordInput_textField'),
      obscureText: _secureText,
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: () => FocusScope.of(context).requestFocus(FocusNode()),
      // validator: (v) => v!.length < 4 ? "Valid password" : null,
      onChanged: (password) =>
          context.read<SignupBloc>().add(SignupPasswordChanged(password)),
      decoration: InputDecoration(
        filled: true,
        hintText: "Password",
        labelText: "Password",
        errorText: state.password.displayError != null
            ? 'Use 8 or more characters, a mix of symbols, number'
            : null,
        fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        alignLabelWithHint: true,
        suffixIcon: IconButton(
          onPressed: showHide,
          icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility,
              color: _secureText ? Colors.grey : const Color(0xFF757575)),
        ),
      ),
    );
  }
}

// Confirm Password Input
class _ConfirmPasswordInput extends StatefulWidget {
  @override
  State<_ConfirmPasswordInput> createState() => _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<_ConfirmPasswordInput> {
  bool _secureText = true;

  // Show . hide password
  void showHide() => setState(() => _secureText = !_secureText);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) => _confirmedPasswordInput(context, state),
    );
  }

  TextFormField _confirmedPasswordInput(
      BuildContext context, SignupState state) {
    return TextFormField(
      key: const Key('signUpForm_confirmedPasswordInput_textField'),
      obscureText: _secureText,
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: () => FocusScope.of(context).requestFocus(FocusNode()),
      // validator: (v) => v!.length < 4 ? "Valid password" : null,
      onChanged: (confirmPassword) => context
          .read<SignupBloc>()
          .add(SignupConfirmedPasswordChanged(confirmPassword)),
      decoration: InputDecoration(
        filled: true,
        hintText: "Confirm Password",
        labelText: "Confirm Password",
        errorText: state.confirmedPassword.displayError != null
            ? 'Passwords do not match'
            : null,
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

// SignUp Button
class _SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? showCircularProgress(width: 15, height: 15)
            : buildOutlinedButton(
                context,
                'Sign Up',
                key: const Key('SignupForm_continue_raisedButton'),
                onPress: state.isValid
                    ? () => context
                        .read<SignupBloc>()
                        .add(const SignupFormSubmitted())
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
