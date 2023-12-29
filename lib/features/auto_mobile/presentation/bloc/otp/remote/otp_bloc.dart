import 'package:dio/dio.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:automasters/features/auto_mobile/presentation/form_models/phone_number.dart';
import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';

part 'otp_event.dart';

part 'otp_state.dart';

class VerifyOTPBloc extends Bloc<OTPEvent, OTPState> {
  VerifyOTPBloc({
    required AuthRepositoryImpl authRepository,
  })  : _authRepository = authRepository,
        super(const OTPState()) {
    on<VerifyOTPSubmitted>(
      _onOTPCodeSubmitted,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  final AuthRepositoryImpl _authRepository;

  Future<void> _onOTPCodeSubmitted(
    VerifyOTPSubmitted event,
    Emitter<OTPState> emit,
  ) async {
    // if(!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authRepository.verifySignup(phoneNumber: event.phoneNumber);

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

class ResendOTPBloc extends Bloc<OTPEvent, OTPState> {
  ResendOTPBloc({
    required AuthRepositoryImpl authRepository,
  })  : _authRepository = authRepository,
        super(const OTPState()) {
    on<OTPResendSubmitted>(
      _onResendOTPSubmitted,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  final AuthRepositoryImpl _authRepository;

  Future<void> _onResendOTPSubmitted(
    OTPResendSubmitted event,
    Emitter<OTPState> emit,
  ) async {
    // if(!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authRepository.sendOTP(
        resendOTP: true,
        phoneNumber: event.phoneNumber,
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

class ChangeOTPPhoneBloc extends Bloc<OTPEvent, OTPState> {
  ChangeOTPPhoneBloc({
    required AuthRepositoryImpl authRepository,
  })  : _authRepository = authRepository,
        super(const OTPState()) {
    on<OTPPhoneChanged>(_onPhoneChanged);
    on<OTPPhoneFormSubmitted>(
      _onSubmitted,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );
  }

  final AuthRepositoryImpl _authRepository;

  void _onPhoneChanged(
    OTPPhoneChanged event,
    Emitter<OTPState> emit,
  ) {
    final phoneNumber = PhoneNumber.dirty(event.phoneNumber);
    emit(
      state.copyWith(
        phoneNumber: phoneNumber,
        isValid: Formz.validate([state.phoneNumber, phoneNumber]),
      ),
    );
  }

  Future<void> _onSubmitted(
    OTPPhoneFormSubmitted event,
    Emitter<OTPState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      try {
        await _authRepository.changeOTPPhone(phoneNumber: state.phoneNumber.value);
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
