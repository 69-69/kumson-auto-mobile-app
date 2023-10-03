import 'dart:io';
import 'dart:math';

class TextTools {

  /// Get initials from full name
  /// example: getInitials('steve tony'), will print ST
  static String getInitials({required String fullName}) => fullName.isNotEmpty
      ? fullName
          .trim()
          .split(RegExp(' +'))
          .map((l) => toUppercaseFirstLetter(text: l[0]))
          .take(2)
          .join()
      : '';

  /// Get Username from email Address[createUsernameFromEmail]
  static String createUsernameFromEmail({required String email}) =>
      email.isNotEmpty ? email.split('@')[0] : '';

  /// Strip off recipient's userId from chatRoomId(example: idFrom_idTo)[stripFromNameInChatRoomId]
  static String stripUserIdFromChatRoomId(
          {required String chatRoomId, required String idFrom}) =>
      chatRoomId.isNotEmpty
          ? chatRoomId.replaceAll(idFrom, "").replaceAll("_", "")
          : '';

  /// Generate chatRoom Id from two userId(idFrom & idTo)[createChatRoomIdFromUserId]
  static String createChatRoomIdFromUserId(String a, String b) {
    return (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0))
        ? "${b}_$a"
        : "${a}_$b";
  }

  /// Regex to remove any preFix/leading char
  static removePrefix(String s, dynamic whatToRemove) =>
      (s.trim()).replaceAll(RegExp('${r'^' + whatToRemove}+(?=.)'), '');

  ///  Strip leading zero from phone no.
  static stripLeadingZero(String s) => '233${removePrefix(s, '0')}';

  /// Auto-Generate OTP Verification Codes
  static String otpCode({int len=4}) {
    final r = Random();
    return List<int>.generate(len, (index) => r.nextInt(10))
        .fold<String>("", (prev, i) => prev += i.toString());
  }

  /// Generate AlphaNumeric chars
  static String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  /// This will put the first letter in UpperCase, will print 'Name'
  /// print(TextTools.toUppercaseFirstLetter(text: 'name'));
  /// This will put the first letter in UpperCase, will print 'What Is Your Name'
  /// print(TextTools.toUppercaseFirstLetter(text: 'what is your name'));
  static toUppercaseFirstLetter({required String text}) {
    text =  text.isEmpty ? text : text.replaceFirst(text[0], text[0].toUpperCase());
    return text;
  }

  /// This will put the first letter in UpperCase, will print 'What Is Your Name'
  /// print(TextTools.toUppercaseFirstLetterEach('what is your name'));
  static String toUppercaseFirstLetterEach(String s) {
    return s.isEmpty ? s :s
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// This will put the letter in position 1 in UpperCase, will print 'nAme'
  /// print(TextTools.toUppercaseAnyLetter(text: 'name', position: 1));
  static toUppercaseAnyLetter({required String text, required int position}) {
    text = text.replaceFirst(text[position], text[position].toUpperCase());
    return text;
  }

  /// This will put the all letters in LowerCase, will print 'name'
  /// print(TextTools.toLowercaseFirstLetter(text: 'NAME'));
  static toLowercaseAllLetter({required String text}) {
    text = text.toLowerCase();
    return text;
  }

  /// This will put the first letter in LowerCase, will print 'nAME'
  /// print(TextTools.toLowercaseFirstLetter(text: 'NAME'));
  static toLowercaseFirstLetter({required String text}) {
    text = text.replaceFirst(text[0], text[0].toLowerCase());
    return text;
  }

  /// This will put the letter in position 1 in LowerCase, will print 'NaME'
  /// print(TextTools.toLowercaseAnyLetter(text: 'NAME'));
  static toLowercaseAnyLetter({required String text, required int position}) {
    text = text.replaceFirst(text[position], text[position].toLowerCase());
    return text;
  }

  /// This will remove all numbers in the String, will print 'name'
  /// print(TextTools.removeNumbersFromString(text: 'name123'));
  static removeNumbersFromString({required String text}) {
    List number = [
      '_',
      ':',
      '-',
      '/',
      ';',
      '|',
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9'
    ];
    for (int i = 0; i < number.length; i++) {
      text = text.replaceAll(number[i].toString(), '');
    }
    return text;
  }

  /// This will remove all letters in the String, will print '123'
  /// print(TextTools.removeLettersFromString(text: 'name123'));
  static removeLettersFromString({required String text}) {
    List letter = [
      '_',
      ':',
      '-',
      ';',
      '/',
      '|',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z'
    ];
    for (int i = 0; i < letter.length; i++) {
      text = text.toLowerCase().replaceAll(letter[i].toString(), '');
    }
    return text;
  }

  /// This will remove the number '1' in the String, will print 'name23'
  /// print(TextTools.removeNumberFromString(text: 'name123', number: 1));
  static removeNumberFromString({required String text, required int number}) {
    text = text.replaceAll(number.toString(), '');
    return text;
  }

  /// This will remove the letter 'a' in the String, will print 'nme123'
  /// print(TextTools.removeLetterFromString(text: 'name123', letter: 'a'));
  static removeLetterFromString(
      {required String text, required String letter}) {
    text = text.toLowerCase().replaceAll(letter.toString(), '');
    return text;
  }

  /// Apple caps: the first letter in Lowercase, second letter in UpperCase,
  /// Other words in toUppercaseFirstLetter, will print 'iPhone 12 Pro max'
  /// print(TextTools.appleWay(text: 'iphone 12 pro max'));
  static String appleWay({required String text}) {
    text = text.toLowerCase();
    return (text.contains("iphone") || text.contains(RegExp("ipad"), 0))
        ? toUppercaseAnyLetter(text: text, position: 1)
        : toUppercaseFirstLetter(text: text);
  }

  /// Products Specs only: Uppercase first letter that has column in front,
  /// will print 'Condition: new, Unlock: factory'
  /// print(TextTools.descCase(text: 'condition: new, unlock: factory'));
  static String toUppercaseFirstLetterWithRow({String? text}) {
    if (text!.length <= 1) return text.toUpperCase();
    dynamic words = text.split(',');

    dynamic capitalized = words.map((word) {
      // get index
      int index = words.indexOf(word);
      int pos = index == 0 ? 1 : 2;

      String first = word.substring(0, pos).toUpperCase();
      String rest = word.substring(pos);
      // Replace all 'null' and 'none' with 'not applicable' from String
      String escapeChar = ('$first$rest'.replaceAll('null', 'not applicable'))
          .replaceAll('none', 'not applicable');

      return escapeChar;
    });
    return capitalized.join('\n');
  }

  /// Convert from one data-type to another
  static toTypeCast(dynamic value, String flag) {
    if (value == null) {
      return value;
    }

    Object? res;
    switch (flag) {
      case "str":
        res = value.toString();
        break;
      case "int":
        res = int.parse(value.toString()).toInt();
        break;
      case "double":
        res = double.tryParse(value.toString()); //.toDouble();
        break;
    }
    return res;
  }

  /// File exist in local directory
  static bool fileExist(i) => File(i).existsSync();

}
