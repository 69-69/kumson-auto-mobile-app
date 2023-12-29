import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';

const _duration = Duration(milliseconds: 500);

/*debouncing is a technique that controls the firing of
repetitive events by delaying their execution.
This prevents rapid or excessive triggering of events.*/
EventTransformer<T> debounce<T>({Duration? duration}) {
  return (events, mapper) =>
      events.debounceTime(duration ?? _duration).flatMap(mapper);
}

/// Regex to remove any multiple preFix/leading chars
removePrefix(String s, dynamic whatToRemove) {
  RegExp regExp = RegExp('${r'^' + whatToRemove}+(?=.)');
  return regExp.hasMatch(s) ? (s.trim()).replaceAll(RegExp('${r'^' + whatToRemove}+(?=.)'), '') : whatToRemove;
}

/// Remove leading '+'
stripLeadingPlus(String s) => s.replaceFirst(RegExp(r'^\+'), '');

// Remove leading 'zeros'
stripLeadingZero(String s) => s.replaceFirst(RegExp(r'^0+'), '');

/*
  * Remove leading zero from [area code]
  * Ex: 024 == 24 -> +233 024 105 9995 == +233 24 105 9995
  * [+] = +,
  * [country code] = 233,
  * [area code] = 024,
  * [subscriber number] = 1059995
  * */
stripZeroFromPhoneAreaCode(String text, int countryCode) {
  if (text.length > countryCode &&
      text.substring(countryCode, countryCode + 1) == '0') {
    final phone =
        text.substring(0, countryCode) + text.substring(countryCode + 1);

    return phone;
  }
  return text;
}

/// Auto-Generate OTP Verification Codes
String generateOTP({int len = 5}) {
  final r = Random();
  return List<int>.generate(len, (index) => r.nextInt(10))
      .fold<String>("", (prev, i) => prev += i.toString());
}

/// Get initials from full name
/// example: getInitials('steve tony'), will print ST
String getInitials({required String fullName}) => fullName.isNotEmpty
    ? fullName
        .trim()
        .split(RegExp(' +'))
        .map((l) => l[0].toUpperCase())
        .take(2)
        .join()
    : '';

createNewMap(dynamic oldMap) {
  Map<String, dynamic> map = Map<String, dynamic>.from(oldMap);
  // Map<String, dynamic> map = { for (var e in oldMap) e.toString() : e };

  /*Map<String, dynamic> map = Map.fromIterable(
    oldMap,
    key: (k) => k.toString(),
    value: (v) => v,
  );*/
  // Map.from(oldMap);
  // Map.of(oldMap);
  return map;
}
