// Automatic FlutterFlow imports
import 'package:content_resolver/content_resolver.dart';

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
  var _successfullUploadCount = 0;
  var _errorUploadCount = 0;
  var _totalCount = double.infinity;
  var _isUploading = false;
  late final Future _startupTask;
  var _isInitialized = false;

  // Can be initialized only once
  Uploader._() : userId = FirebaseAuth.instance.currentUser!.uid {
    _startupTask =
        SQLiteManager.instance.fetchImagesToUpload().then((rows) async {
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
  double get progress => _uploadedCount / _totalCount;

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
    _totalCount++;
    uploadImages();
    _appState?.update(() {
      _appState!.isUploading = _isUploading;
      _appState!.uploadCount = _uploadedCount.toDouble();
    });
  }

  Future<void> removeFromUploadQueue(String path) async {
    _uploadQueue.removeWhere((item) => item.path == path);
    _totalCount--;
    _appState?.update(() {
      _appState!.isUploading = _isUploading;
      _appState!.uploadCount = _uploadedCount.toDouble();
    });
    await SQLiteManager.instance.deleteImage(path: path);
  }

  Future<void> uploadImages() async {
    if (_isUploading) return;

    var didUpload = false;

    final notifPlugin = FlutterLocalNotificationsPlugin();
    await notifPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_mono'),
      ),
    );

    if (_uploadQueue.isNotEmpty) {
      _isUploading = true;
      _uploadedCount = 0;
      _successfullUploadCount = 0;
      _errorUploadCount = 0;
      _totalCount = _uploadQueue.length.toDouble();
      _appState?.update(() {
        _appState!.isUploading = _isUploading;
        _appState!.uploadCount = _uploadedCount.toDouble();
      });
    }

    if (_totalCount < double.infinity) {
      await notifPlugin.show(
        1234,
        'Finding Faces',
        'Finding Faces in your images',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'com.smoose.photoowldev.uploads',
            'Upload notification',
            channelDescription: 'To show notifications for upload progress',
            importance: Importance.min,
            progress: _uploadedCount.round(),
            maxProgress: _totalCount.round(),
            showProgress: true,
            ongoing: true,
            silent: true,
            onlyAlertOnce: true,
          ),
        ),
      );
    }

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
        late Reference ref;
        if (row.path.startsWith('content://')) {
          final image = await ContentResolver.resolveContent(row.path);
          final fileName = image.fileName;
          ref = FirebaseStorage.instance.ref('$userId/uploads/$fileName');
          await ref.putData(
            image.data,
            SettableMetadata(contentType: image.mimeType),
          );
        } else {
          final filePath = row.path;
          final fileName = basename(filePath);
          ref = FirebaseStorage.instance.ref('$userId/uploads/$fileName');
          await ref.putFile(
            File(filePath),
            SettableMetadata(
              contentType: mime(fileName),
            ), // Set the content type here
          );
        }

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
        // Counting successful operation
        _successfullUploadCount++;
      } catch (e) {
        if (e is FirebaseException) {
          if (e.code == "unknown") {
            //happens when photo is added without write permission
            //happens when photo is deleted before the upload action
          }
        }

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
        _errorUploadCount++;
      } finally {
        _uploadQueue.removeFirst();
        _uploadedCount++;
        _appState?.update(() {
          _appState!.isUploading = _isUploading;
          _appState!.uploadCount = _uploadedCount.toDouble();
        });
        didUpload = true;
        await notifPlugin.show(
          1234,
          'Finding Faces',
          'Finding Faces in your images',
          NotificationDetails(
            android: AndroidNotificationDetails(
              'com.smoose.photoowldev.uploads',
              'Upload notification',
              channelDescription: 'To show notifications for upload progress',
              importance: Importance.min,
              progress: _uploadedCount.round(),
              maxProgress: _totalCount.round(),
              showProgress: true,
              ongoing: true,
              silent: true,
              onlyAlertOnce: true,
            ),
          ),
        );
      }
    }

    if (didUpload && _uploadedCount > 0) {
      _isUploading = false;
      await notifPlugin.cancel(1234);
      _appState?.update(() {
        _appState!.isUploading = _isUploading;
      });
      if (_successfullUploadCount > 0) {
        await notifPlugin.show(
          1235,
          'Matching with friends',
          'Searching for friends in the photos you took',
          const NotificationDetails(
            android: AndroidNotificationDetails(
                'com.smoose.photoowldev.info', 'Social Gallery notifs',
                channelDescription: 'Any notification from Social Gallery',
                silent: true,
                indeterminate: true,
                showProgress: true,
                ongoing: true),
          ),
        );
      }
    }
  }
}

Future uploader() async {}
