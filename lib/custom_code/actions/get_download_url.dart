// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
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
  String imageId,
) async {
  final snap =
      await FirebaseFirestore.instance.collection('uploads').doc(imageId).get();
  final key = (snap.data())?['key'];
  if (key == null) return '';

  // Create a reference to the file you want to download
  Reference ref = FirebaseStorage.instance
      .ref()
      .child('users/' + userid + '/uploads/' + key);

  // Get the download URL
  String url = await ref.getDownloadURL();

  return url;
}
