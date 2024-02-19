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

Future<String> addurl(
  List<String> urls,
  String id,
) async {
  var db = await FirebaseFirestore.instance;
  await db.collection('users').doc(id).update({'upload_progress': 0});
  var albumDocument = db.collection('albums').doc();
  print(albumDocument.id);
  DateTime now = DateTime.now();

  String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  await albumDocument.set({
    'owner_id': id,
    'created_at': FieldValue.serverTimestamp(),
    'album_name': formattedDateTime,
    'id': albumDocument.id
  });
  for (var url in urls) {
    await db.collection('uploads').add({
      'upload_url': url,
      'owner_id': id,
      'uploaded_at': FieldValue.serverTimestamp(),
      'album_id': albumDocument.id
    });
    await Future.delayed(Duration(milliseconds: 500));
    double percent = ((urls.indexOf(url) + 1) / urls.length) * 100;
    await db.collection('users').doc(id).update({'upload_progress': percent});
  }
  print('returning albumDocument ID' + albumDocument.id);
  return albumDocument.id;
  // Add your function code here!
}
