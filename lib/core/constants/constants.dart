import 'package:flutter/material.dart';

// PART-No: BKR5ES
// VIN: 19unc1b14hy000003 - 19unc1b04hy000002

const String appName = "AutoMasters";
final passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
final RegExp emailRegExp = RegExp(
  r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
);

const String automobileAPIBaseURL = "http://ec2-18-188-42-121.us-east-2.compute.amazonaws.com";
// "http://localhost:8080";
const String isAPILiveUrl = "$automobileAPIBaseURL/api/v1/auth";
const String refreshTokenUrl =
    "$automobileAPIBaseURL/api/v1/auth/refresh/token";
// PRODUCTION
const String prodPath = "/api/v1/auto";
const String authPath = "/api/v1/auth";
// TESTING
const String devPath = "/test/runner/2023/k1";
const String kDefaultPartImage = "assets/part-p.png";
const String kDefaultCarImage = "assets/car3.png";
const String kHomeBg = "assets/home-bg.jpg";
const String kLogo = "assets/logo.png";
const ghCediSign = "GH";

// Pagination Request
const pagerPage = 0;
const pagerSize = 300;
const pagerSort = "id";
const pagerOrder = "asc";

const Map<String, dynamic> apiEndpoints = {
// DEV / TEST ROUTES
  "dev": {
    "login": "$authPath/login",
    "register": "$authPath/register",
    "userExist": "$authPath/user_exist",
    "refreshToken": "$authPath/refresh/token",
    "confirmEmail": "$authPath/register/confirm_email",
    "resendConfirmEmail": "$authPath/resend_confirm_email",
    "vehicle": "$devPath/auto_cars",
    "part": "$devPath/car_parts",
    "hunter": "$devPath/parts_hunter",
    "make": "$devPath/car_makes",
    "model": "$devPath/car_models",
    "vendor": "$devPath/vendors_parts"
  },
// DEV / TEST ROUTES
  "prod": {
    "login": "$authPath/login",
    "register": "$authPath/register",
    "userExist": "$authPath/user_exist",
    "refreshToken": "$authPath/refresh/token",
    "confirmEmail": "$authPath/register/confirm_email",
    "resendConfirmEmail": "$authPath/resend_confirm_email",
    "vehicle": "$prodPath/vehicles",
    "part": "$prodPath/parts",
    "hunter": "$prodPath/hunting",
    "make": "$prodPath/make",
    "model": "$prodPath/model",
    "vendor": "$prodPath/vendor"
  }
};

const Map<String, String> customHeaders = {
  "Content-Type": "application/json; charset=UTF-8",
  "Authorization":
      "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkZXZtYWlsMDI2QGdtYWlsLmNvbSIsImlhdCI6MTY5OTY0MjU1MSwiZXhwIjoxNzMxMTc4NTUxfQ.3qYTmRe_fXy6Ef3DfOIuv2cl-T4LGw8OIPEEr5ses6o",
};

const Color kPrimaryColor = Color(0xFF4F5298);
