import 'package:automasters/core/constants/constants.dart';
import 'package:formz/formz.dart';

enum NameOrRoleValidationError { invalid }

class NameOrRole extends FormzInput<String, NameOrRoleValidationError> {
  const NameOrRole.pure() : super.pure('');

  const NameOrRole.dirty([super.value = '']) : super.dirty();

  @override
  NameOrRoleValidationError? validator(String? value) {
    return nameRegExp.hasMatch(value ?? '')
        ? null
        : NameOrRoleValidationError.invalid;
  }
}
