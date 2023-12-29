abstract class AuthRepository {

  Future<void> logIn({
    required String emailOrPhone,
    required String password,
  });

  Future<void> forgotPassword({required String emailOrPhone});

  Future<void> changeOTPPhone({required String phoneNumber});

  Future<void> signUp({
    required String email,
    required String role,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String password,
  });

  Future<void> temporalToken();

  Future<void> verifySignup({required String phoneNumber});

  Future<void> sendOTP({
    String? otpCode,
    String? phoneNumber,
    bool resendOTP = false,
  });

  Future<void> logOut();
}
