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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:mime_type/mime_type.dart';

Future uploadImagesFromSqlite(String userId, Future Function() onUpload) async {
  // Add your function code here!
  // Open the database
  final maps = await SQLiteManager.instance.database.rawQuery(
    'SELECT * FROM Images WHERE is_uploaded = 0 AND owner = ? ORDER BY unix_timestamp ASC',
    [userId],
  );

  for (var map in maps) {
    // Update the SQLite row
    await SQLiteManager.instance.database.update(
      'Images',
      {'is_uploading': 1},
      where: "path = ?",
      whereArgs: [map['path']],
    );

    // Upload the image to Firebase Storage
    final filePath = map['path'] as String;
    final fileName = basename(filePath);
    final ref = FirebaseStorage.instance.ref('$userId/uploads/$fileName');
    await ref.putFile(
      File(filePath),
      SettableMetadata(
          contentType: mime(fileName)), // Set the content type here
    );

    // Get the URL of the uploaded image
    final url = await ref.getDownloadURL();

    // Query Firestore
    final snapshot = await FirebaseFirestore.instance
        .collection('uploads')
        .where('owner_id', isEqualTo: userId)
        .orderBy('uploaded_at', descending: true)
        .limit(1)
        .get();

    String? albumId;
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
          (map['unix_timestamp'] as int) * 1000);
      final diff = timestamp.difference(doc['uploaded_at'].toDate());
      if (diff.inMinutes < 15) {
        albumId = doc['album_id'];
      }
    }

    final timestamp = DateTime.fromMillisecondsSinceEpoch(
        (map['unix_timestamp'] as int) * 1000);

    if (albumId == null) {
      // Create a new album document
      final albumDoc =
          await FirebaseFirestore.instance.collection('albums').add({});
      await albumDoc.update({
        'album_name': timestamp.toIso8601String(),
        'created_at': timestamp,
        'owner_id': userId,
      });

      albumId = albumDoc.id;
    }

    // Create the document on Firestore
    await FirebaseFirestore.instance.collection('uploads').add({
      'album_id': albumId,
      'owner_id': userId,
      'upload_url': url,
      'uploaded_at': timestamp,
    });

    // Update the SQLite row
    await SQLiteManager.instance.database.update(
      'Images',
      {'is_uploading': 0, 'is_uploaded': 1},
      where: "path = ?",
      whereArgs: [map['path']],
    );

    onUpload();
  }
}
