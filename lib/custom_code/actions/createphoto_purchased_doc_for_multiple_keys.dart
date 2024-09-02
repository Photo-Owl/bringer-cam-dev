// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future createphotoPurchasedDocForMultipleKeys(
  List<String> imageKeys,
  String paymentRequestId,
  String createdTime,
  String uid,
) async {
  // add document for every image key in premiumPhotoPurchases collection with key
  for (String key in imageKeys) {
    print('createphotoPurchasedDoc function started');
    await FirebaseFirestore.instance
        .collection('premiumPhotoPurchases')
        .doc()
        .set({
      'payment_request_id': paymentRequestId,
      'created_at': createdTime,
      'uid': uid,
      'key': key,
      'status': 'Pending'
    });
  }
}
