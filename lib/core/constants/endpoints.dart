// PART-No: BKR5ES
// VIN: 19unc1b14hy000003 - 19unc1b04hy000002

// Pagination Request
const pagerPage = 0;
const pagerSize = 300;
const orderAsc = "asc";
const orderDesc = "desc";

class EndPoints {
  // "http://localhost:8080";
  static const String apiBaseUrl = "http://ec2-18-188-42-121.us-east-2.compute.amazonaws.com";

  // AUTH-PRODUCTION PURPOSES ONLY
  static const String authPath = "/api/v1/auth";

  // PRODUCTION PURPOSES ONLY
  static const String autoProdPath = "/api/v1/auto";

  // DEVELOPMENT/TESTING PURPOSES ONLY
  static const String autoTestPath = "/test/runner/2023/k1";

  // AUTH-PATHS: Don't need ACCESS_TOKEN
  static const String login = '$apiBaseUrl$authPath/login';
  static const String register = '$apiBaseUrl$authPath/register';
  static const String userExist = '$apiBaseUrl$authPath/user_exist';
  static const String forgotPassword = '$apiBaseUrl$authPath/forgot_password';
  static const String confirmViaEmail = '$apiBaseUrl$authPath/register/confirm_email';
  static const String confirmViaSMS = '$apiBaseUrl$authPath/register/confirm_phone';
  static const String resendConfirmEmail = '$apiBaseUrl$authPath/resend_confirm_email';

  // Restricted/Protected Endpoints: needs ACCESS TOKEN as Bearer-Token
  static const String logout = '$apiBaseUrl$authPath/logout';
  // Restricted/Protected Endpoints: needs REFRESH TOKEN as Bearer-Token
  static const String refreshTokenUrl = '$apiBaseUrl$authPath/refresh/token';

  // WhiteList AUTH-PATHS (UnSecured): Not Restricted by JWT-Token
  static final whiteList = <String>[
    login,
    register,
    userExist,
    confirmViaSMS,
    confirmViaEmail,
    resendConfirmEmail,
  ];

  // USER-PATHS (Secured by JWT): needs ACCESS TOKEN as Bearer-Token
  static const String user = '$apiBaseUrl$autoTestPath/auto_users'; // '/user';
  static const String getLoggedInUser = '$user/loggedInUser'; // '/user';
  static const String smsConfig = '$user/sms_config';

  // AUTO-PRODUCTS-PATHS (Secured by JWT): needs ACCESS TOKEN as Bearer-Token
  static const String vehicle = '$autoTestPath/auto_cars'; //Prod-Path:: '/vehicles';
  static const String vehicleByVic = '$vehicle/v_code';

  static const String product = '$autoTestPath/car_products'; //Prod-Path:: '/parts';

  static const String part = '$autoTestPath/car_parts'; //Prod-Path:: '/parts';
  static const String partsByHunterNo = '$part/hunter';
  static const String partsYearsByMakeAndModel = '$part/year_range';

  static const String hunter = '$autoTestPath/parts_hunter'; //Prod-Path:: '/hunting';
  static const String huntersByPartNo = '$hunter/part_no';

  static const String make = '$autoTestPath/car_makes'; //Prod-Path:: '/make';

  static const String model = '$autoTestPath/car_models'; //Prod-Path:: '/model';
    static const String modelsByMakeRef = '$model/make_ref';

  static const String vendor = '$autoTestPath/vendors_parts'; //Prod-Path:: '/vendor';
  static const String vendorsByBrandAndPartNo = '$vendor/lowest_price';

  static const Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };
  static const Map<String, bool> forceDioHttpRefresh = {'refresh': true};

  // NALO SMS Auth-Info
  static const naloSmsSenderID = "AUTOMASTERS";
  static const naloUrl = "https://sms.nalosolutions.com/smsbackend/Resl_Nalo/send-message/";
  static const naloSMSApiKey = "q9tg0kd#y((xg07sf7(mzwunp(1ur1d6_qiev7p4bv3hc49953xzz3(s04gu(mkt";
}
