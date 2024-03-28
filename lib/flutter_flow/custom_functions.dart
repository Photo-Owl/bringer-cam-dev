import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/auth/firebase_auth/auth_util.dart';

String convertToImagePath(String url) {
  // convert the url from String to ImagePath
  if (url.startsWith('http')) {
    return url;
  } else {
    return 'https://firebasestorage.googleapis.com/v0/b/bringer-cam-dev.appspot.com/o/' +
        url +
        '?alt=media';
  }
}

DateTime add1Hour() {
  DateTime currentTime = DateTime.now();
  DateTime oneHourFromNow = currentTime.add(Duration(hours: 1));
  return oneHourFromNow;
}

DateTime todayEvening() {
  DateTime currentDate = DateTime.now();

  // Set the desired time to 5 PM
  DateTime desiredTime =
      DateTime(currentDate.year, currentDate.month, currentDate.day, 17, 0, 0);
  return desiredTime;
}

DateTime tommorowEvening() {
  DateTime currentDate = DateTime.now();

  // Set the desired time to 5 PM
  DateTime desiredTime =
      DateTime(currentDate.year, currentDate.month, currentDate.day, 17, 0, 0);

  return desiredTime.add(Duration(days: 1));
}

int divisibilityCheck(
  int itemCount,
  int req,
) {
  return itemCount % req;
}
