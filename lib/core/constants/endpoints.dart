class EndPoints {
  bool prod;

  EndPoints({this.prod = false});

  // _getBasePath() => prod ? prodPath : devPath;

  // _getBaseUrl() => prod ? awsBaseUrl : automobileAPIBaseURL;

  static const String automobileAPIBaseURL = "http://localhost:8080";
  static const String awsBaseUrl =
      "http://ec2-18-188-42-121.us-east-2.compute.amazonaws.com";

  // PRODUCTION PURPOSES ONLY
  static const String autoProdPath = "/api/v1/auto";

  // AUTH-PRODUCTION PURPOSES ONLY
  static const String authPath = "/api/v1/auth";

  // DEVELOPMENT PURPOSES ONLY
  static const String autoDevPath = "/test/runner/2023/k1";

  // AUTH-PATHS
  static const String login = '/login';
  static const String register = '/register';
  static const String userEmail = '/user_exist';
  static const String refreshToken = '/refresh/token';
  static const String confirmEmail = '/register/confirm_email';
  static const String resendConfirmEmail = '/resend_confirm_email';

  // PRODUCTS-PATHS
  static const String vehicle = '/vehicles';
  static const String part = '/parts';
  static const String hunter = '/hunting';
  static const String make = '/make';
  static const String model = '/model';
  static const String vendor = '/vendor';

  static const String refreshTokenUrl =
      "$awsBaseUrl$authPath$refreshToken";

  static final whiteList = <String>[
    "$authPath$login",
    "$authPath$register",
    "$authPath$userEmail",
    "$authPath$refreshToken",
    "$authPath$confirmEmail",
    "$authPath$resendConfirmEmail",
  ];

  static const Map<String, String> customHeaders = {
    "Content-Type": "application/json; charset=UTF-8",
    "Authorization":
        "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkZXZtYWlsMDI2QGdtYWlsLmNvbSIsImlhdCI6MTY5OTY0MjU1MSwiZXhwIjoxNzMxMTc4NTUxfQ.3qYTmRe_fXy6Ef3DfOIuv2cl-T4LGw8OIPEEr5ses6o",
  };
}
