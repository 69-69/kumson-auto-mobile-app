import 'package:automasters/core/constants/constants.dart';
import 'package:formz/formz.dart';

enum EmailOrPhoneValidationError { invalid }

class EmailOrPhone extends FormzInput<String, EmailOrPhoneValidationError> {
  const EmailOrPhone.pure() : super.pure('');
  const EmailOrPhone.dirty([super.value = '']) : super.dirty();

  @override
  EmailOrPhoneValidationError? validator(String? value) {
    return emailRegExp.hasMatch(value ?? '') || value!.length >= 10
        ? null
        : EmailOrPhoneValidationError.invalid;
  }
  /*@override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.empty;
    return null;
  }*/
}