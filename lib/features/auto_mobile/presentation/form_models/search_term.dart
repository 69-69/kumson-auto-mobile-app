import 'package:formz/formz.dart';

enum SearchTermValidationError { invalid }

class SearchTerm extends FormzInput<String, SearchTermValidationError> {
  const SearchTerm.pure() : super.pure('');

  const SearchTerm.dirty([super.value = '']) : super.dirty();

  @override
  SearchTermValidationError? validator(String? value) {
    return value!.isNotEmpty ? null : SearchTermValidationError.invalid;
  }
}
