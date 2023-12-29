import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:automasters/core/util/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:automasters/features/auto_mobile/data/models/otp.dart';
import 'package:automasters/features/auto_mobile/data/models/signup.dart';
import 'package:automasters/features/auto_mobile/data/models/user.dart';
import 'package:automasters/features/auto_mobile/data/repositories/auth_repository_impl.dart';
import 'package:automasters/features/auto_mobile/data/repositories/user_repository_impl.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepositoryImpl authRepository,
    required UserRepositoryImpl userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthState.unknown())
  /*super(
          authRepository.currentUser.isNotEmpty
              ? AuthState.authenticated(authRepository.currentUser)
              : (authRepository.currentSignup.isNotEmpty &&
                      authRepository.currentOTP.isNotEmpty
                  ? AuthState.continueSignup(
                      authRepository.currentSignup,
                      authRepository.currentOTP,
                    )
                  : const AuthState.unknown()),
        )*/
  {
    on<_AuthStatusChanged>(
      _onAuthStatusChanged,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );

    on<AuthLogoutRequested>(_onAuthLogoutRequested);

    _authStatusSubscription = _authRepository.status.listen(
      (status) => add(_AuthStatusChanged(status)),
    );

    /*on<VerifySignupRequested>(
      _onVerifySignupRequested,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );

    on<ResendOTPRequested>(
      _onResendOTPRequested,

      /// Apply the custom `EventTransformer` to the `EventHandler`.
      transformer: debounce(),
    );*/
  }

  final AuthRepositoryImpl _authRepository;
  final UserRepositoryImpl _userRepository;
  late StreamSubscription<AuthStatus> _authStatusSubscription;

  @override
  Future<void> close() {
    _authStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthStatusChanged(
    _AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    switch (event.status) {
      case AuthStatus.unauthenticated:
        return emit(const AuthState.unauthenticated());

      case AuthStatus.authenticated:
        final user = await _tryGetUser();

        return emit(
          user != null
              ? AuthState.authenticated(user)
              : const AuthState.unauthenticated(),
        );

      case AuthStatus.continueSignup:
        final otp = _authRepository.currentOTP;
        final signupInfo = _authRepository.currentSignup;

        return emit(
          signupInfo.isNotEmpty
              ? AuthState.continueSignup(otp, signupInfo)
              : const AuthState.unauthenticated(),
        );

      case AuthStatus.otpCreated:
        final otp = _authRepository.currentOTP;
        final signupInfo = _authRepository.currentSignup;

        return emit(
          otp.isNotEmpty
              ? AuthState.otpCreated(otp, signupInfo)
              : const AuthState.unauthenticated(),
        );

      case AuthStatus.unknown:
        return emit(const AuthState.unknown());
    }
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    _authRepository.logOut();
  }

  Future<UserModel?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }

/*void _onVerifySignupRequested(
    VerifySignupRequested event,
    Emitter<AuthState> emit,
  ) {
    _authRepository.verifySignup(phoneNumber: event.phoneNumber);
  }

  void _onResendOTPRequested(
    ResendOTPRequested event,
    Emitter<AuthState> emit,
  ) {
    // Re-Send OTP via SMS
    _authRepository.sendOTP(
      resendOTP: true,
      phoneNumber: event.phoneNumber,
    );
    }*/
}
