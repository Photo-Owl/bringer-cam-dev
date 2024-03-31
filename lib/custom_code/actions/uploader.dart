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

import 'dart:collection';
import 'dart:io';
import 'package:path/path.dart' show basename;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime_type/mime_type.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UploadItem {
  final String path;
  final int? unixTimestamp;
  final bool? isUploading;

  const UploadItem({
    required this.path,
    required this.unixTimestamp,
    required this.isUploading,
  });

  @override
  String toString() {
    return path;
  }
}

class Uploader {
  static Uploader? _instance;
  static FFAppState? _appState;
  final String userId;
  final _uploadQueue = ListQueue<UploadItem>();
  var _uploadedCount = 0;
  var _totalcount = double.infinity;
  var _isUploading = false;
  late final Future _startupTask;
  var _isInitialized = false;

  // Can be initialized only once
  Uploader._() : userId = FirebaseAuth.instance.currentUser!.uid {
    _startupTask = SQLiteManager.instance
        .fetchImagesToUpload(ownerId: userId)
        .then((rows) async {
      _uploadQueue.addAll(rows.map(
        (row) => UploadItem(
          path: row.path,
          unixTimestamp: row.unixTimestamp,
          isUploading: row.isUploading == 1,
        ),
      ));
      await uploadImages();
    });
  }

  // Returns the same instance every instance, a singleton
  factory Uploader() {
    _instance ??= Uploader._();
    return _instance!;
  }

  // Singleton is created before Flutter app starts, this is used to
  // hook into the app state to update progress in UI
  set appState(FFAppState state) {
    _appState ??= state;
  }

  bool get isUploading => _isUploading;
  UploadItem? get currentlyUploading =>
      _isUploading ? _uploadQueue.first : null;
  double get progress => _uploadedCount / _totalcount;

  Future<void> waitForUploads() async {
    if (_isInitialized) return;
    await _startupTask;
    _isInitialized = true;
  }

  Future<void> addToUploadQueue(String path, int timestamp) async {
    await SQLiteManager.instance.insertImage(
      path: path,
      ownerId: userId,
      unixTimestamp: timestamp,
    );
    _uploadQueue.add(
      UploadItem(
        path: path,
        unixTimestamp: timestamp,
        isUploading: false,
      ),
    );
    // uploadImages();
    _appState?.update(() {
      _appState!.isUploading = _isUploading;
      _appState!.uploadProgress = progress;
    });
  }

  Future<void> removeFromUploadQueue(String path) async {
    _uploadQueue.removeWhere((item) => item.path == path);
    _appState?.update(() {
      _appState!.isUploading = _isUploading;
      _appState!.uploadProgress = progress;
    });
    await SQLiteManager.instance.deleteImage(path: path);
  }

  Future<void> uploadImages() async {
    if (_isUploading) return;

    final notifPlugin = FlutterLocalNotificationsPlugin();
    await notifPlugin.initialize(
      InitializationSettings(
          android: AndroidInitializationSettings('ic_launcher')),
    );

    if (_uploadQueue.isNotEmpty) {
      _isUploading = true;
      _uploadedCount = 0;
      _totalcount = _uploadQueue.length.toDouble();
      _appState?.update(() {
        _appState!.isUploading = _isUploading;
        _appState!.uploadProgress = progress;
      });
    }
    await notifPlugin.show(
      1234,
      'Uploading images',
      'Uploading images to the cloud',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'com.smoose.photoowldev.uploads',
          'Upload notification',
          channelDescription: 'To show notifications for upload progress',
          importance: Importance.min,
          progress: _uploadedCount.round(),
          maxProgress: _totalcount.round(),
          showProgress: true,
        ),
      ),
    );

    while (_uploadQueue.isNotEmpty) {
      final row = _uploadQueue.first;
      try {
        // Update the SQLite row
        await SQLiteManager.instance.database.update(
          'Images',
          {'is_uploading': 1},
          where: "path = ?",
          whereArgs: [row.path],
        );

        // Upload the image to Firebase Storage
        final filePath = row.path;
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
          final timestamp =
              DateTime.fromMillisecondsSinceEpoch((row.unixTimestamp ?? 0));
          final diff = timestamp.difference(doc['uploaded_at'].toDate());
          if (diff.inMinutes < 15) {
            albumId = doc['album_id'];
          }
        }

        final timestamp =
            DateTime.fromMillisecondsSinceEpoch((row.unixTimestamp ?? 0));

        if (albumId == null) {
          // Create a new album document
          final albumDoc =
              await FirebaseFirestore.instance.collection('albums').add({});
          await albumDoc.update({
            'album_name': timestamp.toIso8601String(),
            'created_at': timestamp,
            'owner_id': userId,
            'id': albumDoc.id,
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
          whereArgs: [row.path],
        );
      } catch (e) {
        if (e is Error) {
          debugPrintStack(stackTrace: e.stackTrace);
        } else {
          debugPrint('$e');
        }

        // Update the SQLite row
        await SQLiteManager.instance.database.update(
          'Images',
          {'is_uploading': 0, 'is_uploaded': 0},
          where: "path = ?",
          whereArgs: [row.path],
        );
      } finally {
        _uploadQueue.removeFirst();
        _appState?.update(() {
          _appState!.isUploading = _isUploading;
          _appState!.uploadProgress = progress;
        });
        await notifPlugin.show(
          1234,
          'Uploading images',
          'Uploading images to the cloud',
          NotificationDetails(
            android: AndroidNotificationDetails(
              'com.smoose.photoowldev.uploads',
              'Upload notification',
              channelDescription: 'To show notifications for upload progress',
              importance: Importance.min,
              progress: _uploadedCount.round(),
              maxProgress: _totalcount.round(),
              showProgress: true,
            ),
          ),
        );
      }
    }
    _isUploading = false;
    _appState?.update(() {
      _appState!.isUploading = _isUploading;
      _appState!.uploadProgress = progress;
    });
  }
}

Future uploader() async {}
