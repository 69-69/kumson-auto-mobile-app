import 'package:flutter/material.dart';

const String appName = "AutoMasters";
const String appSubTitle = "Best Way to Buy Car Parts in Ghana";
const ghCediSign = "GH";
const noReply = "no-reply@automasters-app.com";

const String appLogo = "assets/logo.png";
const String appHomeBg = "assets/home-bg.jpg";
const String kDefaultCarImage = "assets/car3.png";
const String kDefaultPartImage = "assets/part-p.png";

const kTextColor = Color(0xFF757575);
const kLightColor = Color(0xFFF6F7F9);
const kGreyColor = Color(0xFFB1B3B8);
const kErrorColor = Color(0xFFFF4848); //Color(0xFFF62F2F);

// Truncate String to four Char
final RegExp truncateStrRegExp = RegExp(r'(?<=.{4})\d(?=.{4})');

final RegExp nameRegExp = RegExp(r"^[a-zA-Z]+$");

// final RegExp nameRegExp = RegExp(r"^[\p{L} ,.'-]*$", caseSensitive: false, unicode: true, dotAll: true);

final RegExp numberRegExp = RegExp(r"^\d+$");

final RegExp passwordRegExp2 =
    RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

final RegExp passwordRegExp =
    RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[$!%*@#=?&])[A-Za-z\d$!%*@#=?&]{8,}$");

final RegExp emailRegExp = RegExp(
  r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
);

// final RegExp nameRegExp = RegExp(r"^([a-zA-Z]{2,}\s[a-zA-Z]+'?-?[a-zA-Z]{2,}\s?([a-zA-Z]+)?)");
