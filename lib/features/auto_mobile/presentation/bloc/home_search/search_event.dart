part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchChanged extends SearchEvent {
  const SearchChanged(this.searchValue);

  final String searchValue;

  @override
  List<Object> get props => [searchValue];
}

final class SearchFormSubmitted extends SearchEvent {
  const SearchFormSubmitted(this.isVin);

  final bool isVin;

  @override
  List<Object> get props => [isVin];
}

