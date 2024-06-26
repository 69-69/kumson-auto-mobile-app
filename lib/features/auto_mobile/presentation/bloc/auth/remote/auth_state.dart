part of 'auth_bloc.dart';

/*
* [AuthState] instances will be the output of the AuthBloc and will be consumed by the presentation layer.

The [AuthState] class has four named constructors:

[AuthState.unknown()]: the default state which indicates that the bloc does not yet know whether the current user is authenticated or not.

[AuthState.continueSignup()]: the state which indicates that the user is currently in signup process.

[AuthState.authenticated()]: the state which indicates that the user is currently authenticated.

[AuthState.unauthenticated()]: the state which indicates that the user is currently not authenticated.
* */
class AuthState extends Equatable {
  const AuthState._({
    this.status = AuthStatus.unknown,
    this.currentUser = UserModel.empty,
    this.activeSignup = SignupModel.empty,
    this.activeOTP = OTPModel.empty,
  });

  const AuthState.unknown() : this._();

  const AuthState.continueSignup(OTPModel otp, SignupModel signup)
      : this._(
            status: AuthStatus.continueSignup,
            activeOTP: otp,
            activeSignup: signup);

  const AuthState.otpCreated(OTPModel otp, SignupModel signup)
      : this._(
            status: AuthStatus.otpCreated,
            activeOTP: otp,
            activeSignup: signup);

  const AuthState.authenticated(UserModel user)
      : this._(
          status: AuthStatus.authenticated,
          currentUser: user,
        );

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final UserModel currentUser;
  final SignupModel activeSignup;
  final OTPModel activeOTP;

  @override
  List<Object> get props => [status, currentUser, activeSignup, activeOTP];
}
