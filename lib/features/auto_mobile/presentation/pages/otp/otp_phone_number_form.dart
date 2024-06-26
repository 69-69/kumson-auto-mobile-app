import 'package:automasters/core/util/utils.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/size_config.dart';
import 'package:automasters/config/routes/routes_constant.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/parent_background.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/app_local_database.dart';
import 'package:automasters/features/auto_mobile/data/data_sources/local/local_repository_key.dart';
import 'package:automasters/features/auto_mobile/presentation/bloc/otp/remote/otp_bloc.dart';
import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/or_separator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/outline_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/async_progress_dialog.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/elevated_btn.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/widgetery.dart';

class OTPPhoneNumberFrom extends StatefulWidget {
  const OTPPhoneNumberFrom({super.key, this.title});

  final String? title;

  @override
  State<OTPPhoneNumberFrom> createState() => _OTPPhoneNumberFromState();
}

class _OTPPhoneNumberFromState extends State<OTPPhoneNumberFrom> {
  bool isFailed = false;
  bool hideErrorMsg = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final customTheme = Theme.of(context);

    // Lets restart the app so icons can load
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: customTheme.colorScheme.surface,
      body: ParentBackground(
        child: BlocProvider(
          create: (context) {
            return ChangeOTPPhoneBloc(
              authRepository: RepositoryProvider.of<AuthRepositoryImpl>(context),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

  BlocListener<ChangeOTPPhoneBloc, OTPState> _buildBody(BuildContext context) {
    return BlocListener<ChangeOTPPhoneBloc, OTPState>(
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
        child: _buildSignupForm(context),
      ),
    );
  }

  Column _buildSignupForm(BuildContext context) {
    final tColor = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => pageNavigator(context),
              icon: Icon(Icons.adaptive.arrow_back),
            ),
            buildTitleHeader(
              context,
              "Verify Account",
              "Complete your registration.",
            ),
            const SizedBox.shrink()
          ],
        ),
        const Divider(thickness: 1),
        buildChip(
          (isFailed && !hideErrorMsg)
              ? 'Your Email or Mobile number is already in use...try again!'
              : (widget.title ?? 'Enter the Mobile number used in sign up!'),
          onDelete: () => setState(() => hideErrorMsg = true),
        ),
        const Divider(thickness: 0.3, height: 0.2),

        SizedBox(height: getProportionateScreenHeight(20)),
        _PhoneNumberInput(onChanged: (value) {}),
        SizedBox(height: getProportionateScreenHeight(7)),
        _SignupButton(),

        /// Or Section
        orSeparator(
          lineColor: tColor.primary,
          textColor: tColor.primary,
        ),
        buildOutlinedBtn(
          label: 'Start Searching?',
          context,
          borderColor: Colors.transparent,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          onPress: () {
            AppLocalDatabase().deleteCache(key: signupIdCacheKey).whenComplete(
                  () => pageNavigator(
                    context,
                    routeName: appRootRoute,
                  ),
                );
          },
        ),
      ],
    );
  }
}

// Phone Input
class _PhoneNumberInput extends StatelessWidget {
  const _PhoneNumberInput({this.onChanged});

  final Function(String text)? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeOTPPhoneBloc, OTPState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) => _phoneNumberInput(context, state),
    );
  }

  TextFormField _phoneNumberInput(BuildContext context, OTPState state) {
    final CountryDetails details = CountryCodes.detailsForLocale();
    final countryCode = details.dialCode!.length;

    return TextFormField(
      key: const Key('SignupForm_phoneNumberInput_textField'),
      maxLength: 16,
      keyboardType: TextInputType.phone,
      inputFormatters: [DialCodeFormatter()],
      onChanged: (phoneNumber) {
        // Remove leading zeros, if any
        String phone = stripLeadingZero(phoneNumber);

        String phoneWithCountryCode =
        stripZeroFromPhoneAreaCode(phone, countryCode);

        // Remove leading '+', if any
        String number = stripLeadingPlus(phoneWithCountryCode);

        context.read<ChangeOTPPhoneBloc>().add(OTPPhoneChanged(number));
        onChanged!(phoneNumber);
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
    );
  }
}

// SignUp Button
class _SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeOTPPhoneBloc, OTPState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? showCircularProgress(width: 15, height: 15)
            : SizedBox(
                width: SizeConfig.screenWidth,
                child: buildElevatedBtn(
                  key: const Key('change_otp_phone_Form_outlinedButton'),
                  context,
                  label: 'Save Changes',
                  color: Colors.white,
                  onPress: state.isValid
                      ? () => context
                          .read<ChangeOTPPhoneBloc>()
                          .add(const OTPPhoneFormSubmitted())
                      : null,
                ),
              );
      },
    );
  }
}
