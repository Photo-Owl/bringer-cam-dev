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

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_saver/file_saver.dart';

Future<String> getDownloadUrl(
  String userid,
  String key,
) async {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Create a reference to the file you want to download
  Reference ref = storage.ref().child('users/' + userid + '/uploads/' + key);

  // Get the download URL
  String url = await ref.getDownloadURL();

  await FileSaver.instance
      .saveFile(name: key + ".jpeg", link: LinkDetails(link: url));
  return url;
}
