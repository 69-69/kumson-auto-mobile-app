import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

urlToVid(String url){
  try {

    String? videoId = YoutubePlayer.convertUrlToId(url);
    return videoId ?? "";

  } on Exception catch (exception) {

    // only executed if error is of type Exception
    debugPrint(exception.toString());

  } catch (error) {

    // executed for errors of all types other than Exception
    debugPrint(error.toString());
    //  videoIdd="error";

  }
}

convertUrlToId(String url, {bool trimWhitespaces = true}) {
  if (!url.contains("http") && (url.length == 11)) return url;
  if (trimWhitespaces) url = url.trim();

  for (var exp in [
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ]) {
    Match? match = exp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return match.group(1);
  }

  return null;
}

getYoutubeVideoIdByURL (String url) {
  final regex = RegExp(r'.*\?v=(.+?)($|[\&])', caseSensitive: false);

  try {
    if (regex.hasMatch(url)) {
      return regex.firstMatch(url)!.group(1);
    }
  } catch (e) {
    return null;
  }
}