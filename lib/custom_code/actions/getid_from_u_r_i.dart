// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:html';

Future<String?> getidFromURI() async {
  final href = window.location.href;
  print(href);
  final uri = Uri.parse(href);
  final queryString = href.split('?')[1];
  print(queryString);
  final queryParameters = Uri.splitQueryString(queryString);
  print(queryParameters);
  return queryParameters['payment_request_id'];
}
