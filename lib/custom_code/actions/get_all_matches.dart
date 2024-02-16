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

Future<List<String>> getAllMatches(String userRefrence) async {
  var db = await FirebaseFirestore.instance;
  var uploadQuerySnapshot = await db
      .collection('uploads')
      .where('faces', arrayContains: userRefrence)
      .orderBy('albumId')
      .get();
  var uploadDocs = uploadQuerySnapshot.docs;
  var albumSet = Set<String>(); // Using a Set to ensure uniqueness

  for (var doc in uploadDocs) {
    var albumId = doc.data()['album_id'];
    if (albumId != null) {
      albumSet.add(albumId);
    }
  }

  var albumArray = albumSet.toList(); // Converting the Set back to a List
  return albumArray;
}
