part of 'search_bloc.dart';

final class SearchState extends Equatable {
  const SearchState({
    this.searchTerm = const SearchTerm.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.getData,
    this.future,
    this.isValid = false,
    this.errorMessage,
  });

  final SearchTerm searchTerm;
  final FormzSubmissionStatus status;
  final dynamic getData;
  final Future<dynamic>? future;
  final bool isValid;
  final String? errorMessage;

  SearchState copyWith({
    FormzSubmissionStatus? status,
    SearchTerm? searchTerm,
    dynamic getData,
    Future<dynamic>? future,
    bool? isValid,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      searchTerm: searchTerm ?? this.searchTerm,
      getData: getData ?? this.getData,
      future: future ?? this.future,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, isValid, searchTerm, getData, errorMessage];
}
