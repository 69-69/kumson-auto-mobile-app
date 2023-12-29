import 'package:dio/dio.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';
import 'package:automasters/features/auto_mobile/presentation/form_models/index.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required AuthRepositoryImpl authRepository,
  })  : _authRepository = authRepository,
        super(const SignupState()) {
    on<SignupFirstNameChanged>(_onFirstNameChanged);
    on<SignupLastNameChanged>(_onLastNameChanged);
    on<SignupPhoneChanged>(_onPhoneNumberChanged);
    on<SignupUserRoleChanged>(_onRoleChanged);
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupConfirmedPasswordChanged>(_onConfirmedPasswordChanged);
    on<SignupFormSubmitted>(
      _onSubmitted,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  final AuthRepositoryImpl _authRepository;

  void _onEmailChanged(
    SignupEmailChanged event,
    Emitter<SignupState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          email,
          state.userRole,
          state.phoneNumber,
          state.firstName,
          state.lastName,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void _onFirstNameChanged(
    SignupFirstNameChanged event,
    Emitter<SignupState> emit,
  ) {
    final firstName = NameOrRole.dirty(event.firstName);
    emit(
      state.copyWith(
        firstName: firstName,
        isValid: Formz.validate([
          firstName,
          state.email,
          state.userRole,
          state.phoneNumber,
          state.lastName,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void _onLastNameChanged(
    SignupLastNameChanged event,
    Emitter<SignupState> emit,
  ) {
    final lastName = NameOrRole.dirty(event.lastName);
    emit(
      state.copyWith(
        lastName: lastName,
        isValid: Formz.validate([
          lastName,
          state.email,
          state.userRole,
          state.phoneNumber,
          state.firstName,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void _onPhoneNumberChanged(
    SignupPhoneChanged event,
    Emitter<SignupState> emit,
  ) {
    final phoneNumber = PhoneNumber.dirty(event.phoneNumber);
    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        isValid: Formz.validate([
          phoneNumber,
          state.email,
          state.userRole,
          state.firstName,
          state.lastName,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void _onRoleChanged(
    SignupUserRoleChanged event,
    Emitter<SignupState> emit,
  ) {
    final userRole = NameOrRole.dirty(event.userRole);
    emit(
      state.copyWith(
        userRole: userRole,
        isValid: Formz.validate([
          userRole,
          state.email,
          state.phoneNumber,
          state.firstName,
          state.lastName,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    SignupPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final password = Password.dirty(event.password);

    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      confirmedPassword: state.confirmedPassword.value,
    );
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([
          password,
          confirmedPassword,
          state.email,
          state.userRole,
          state.phoneNumber,
          state.firstName,
          state.lastName,
        ]),
      ),
    );
  }

  void _onConfirmedPasswordChanged(
    SignupConfirmedPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      confirmedPassword: event.confirmedPassword,
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid: Formz.validate([
          state.email,
          state.userRole,
          state.phoneNumber,
          state.firstName,
          state.lastName,
          state.password,
          confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> _onSubmitted(
    SignupFormSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authRepository.signUp(
        email: state.email.value,
        role: state.userRole.value,
        phoneNumber: state.phoneNumber.value,
        firstName: state.firstName.value,
        lastName: state.lastName.value,
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
