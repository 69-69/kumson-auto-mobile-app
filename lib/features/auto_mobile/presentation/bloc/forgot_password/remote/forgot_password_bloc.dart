import 'package:dio/dio.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/form_models/email_or_phone.dart';
import 'package:automasters/features/auto_mobile/presentation/form_models/index.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required AuthRepositoryImpl authRepository,
  })  : _authRepository = authRepository,
        super(const ForgotPasswordState()) {
    on<ForgotEmailOrPhoneChanged>(_onEmailOrPhoneChanged);
    on<LoginFormSubmitted>(
      _onSubmitted,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  final AuthRepositoryImpl _authRepository;

  void _onEmailOrPhoneChanged(
    ForgotEmailOrPhoneChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    final emailOrPhone = EmailOrPhone.dirty(event.emailOrPhone);
    emit(
      state.copyWith(
        emailOrPhone: emailOrPhone,
        isValid: Formz.validate([state.password, emailOrPhone]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginFormSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        await _authRepository.forgotPassword(
          emailOrPhone: state.emailOrPhone.value,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
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
