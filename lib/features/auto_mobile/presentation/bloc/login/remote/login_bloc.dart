import 'package:dio/dio.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/presentation/form_models/email_or_phone.dart';
import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/form_models/index.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthRepositoryImpl authRepository,
  })  : _authRepository = authRepository,
        super(const LoginState()) {
    on<LoginEmailOrPhoneChanged>(_onEmailOrPhoneChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginFormSubmitted>(
      _onSubmitted,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  final AuthRepositoryImpl _authRepository;

  void _onEmailOrPhoneChanged(
    LoginEmailOrPhoneChanged event,
    Emitter<LoginState> emit,
  ) {
    final emailOrPhone = EmailOrPhone.dirty(event.emailOrPhone);
    emit(
      state.copyWith(
        emailOrPhone: emailOrPhone,
        isValid: Formz.validate([state.password, emailOrPhone]),
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.emailOrPhone]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginFormSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        await _authRepository.logIn(
          emailOrPhone: state.emailOrPhone.value,
          password: state.password.value,
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
