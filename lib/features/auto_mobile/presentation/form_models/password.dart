import 'package:automasters/core/constants/constants.dart';
import 'package:formz/formz.dart';

enum PasswordValidationError { invalid }

class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro password}
  const Password.pure() : super.pure('');
  /// {@macro password}
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    return passwordRegExp.hasMatch(value ?? '')
        ? null
        : PasswordValidationError.invalid;
  }

}