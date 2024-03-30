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

import 'package:collection/collection.dart';

Future<List<OwnerDetailsStruct>> getOwnerDetails(List<String> owners) async {
  if (owners.isEmpty) return [];
  var splitOwners = owners;
  if (owners.length > 4) {
    splitOwners = owners.slice(0, 4).toList();
  }
  final ownerDetails = await FirebaseFirestore.instance
      .collection('users')
      .where('uid', whereIn: splitOwners)
      .get();
  // TODO: decide on a field for photo urls
  return ownerDetails.docs.map((doc) {
    final data = doc.data();
    return OwnerDetailsStruct(
      name: (data['display_name'] as String? ?? '').split(' ')[0],
      photoURL: data['photo_url'] as String? ?? '',
    );
  }).toList();
}
