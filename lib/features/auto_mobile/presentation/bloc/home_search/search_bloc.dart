import 'dart:async';

import 'package:dio/dio.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/data/repositories/search_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/form_models/search_term.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required SearchRepositoryImpl searchRepository,
  })  : _searchRepository = searchRepository,
        super(const SearchState()) {
    on<SearchChanged>(_onSearchChanged);
    on<SearchFormSubmitted>(
      _onSubmitted,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  final SearchRepositoryImpl _searchRepository;

  void _onSearchChanged(
    SearchChanged event,
    Emitter<SearchState> emit,
  ) {
    final searchInput = SearchTerm.dirty(event.searchValue);
    emit(
      state.copyWith(
        searchTerm: searchInput,
        isValid: Formz.validate([state.searchTerm, searchInput]),
      ),
    );
  }

  Future<void> _onSubmitted(
    SearchFormSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        // Get User's search term
        String searchTerm = state.searchTerm.value;

        Future request = event.isVin
            ? _searchRepository.getVehicleByVin(searchTerm)
            : _searchRepository.getHunterPartsByPartNo(searchTerm);

        final data = await request;
        // debugPrint("bloc $searchTerm == $data == ${event.isVin}");

        emit(
          data != null
              ? state.copyWith(
                  status: FormzSubmissionStatus.success,
                  future: request,
                  getData: data,
                )
              : state.copyWith(
                  status: FormzSubmissionStatus.failure,
                  future: Future.delayed(const Duration(milliseconds: 1)),
                  isValid: false,
                ),
        );
      } on DioException catch (e) {
        emit(
          state.copyWith(
            errorMessage: e.message,
            status: FormzSubmissionStatus.failure,
          ),
        );
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }
}
