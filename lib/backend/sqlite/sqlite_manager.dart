import 'package:flutter/foundation.dart';

import '/backend/sqlite/init.dart';
import 'queries/read.dart';
import 'queries/update.dart';

import 'package:sqflite/sqflite.dart';
export 'queries/read.dart';
export 'queries/update.dart';

class SQLiteManager {
  SQLiteManager._();

  static SQLiteManager? _instance;
  static SQLiteManager get instance => _instance ??= SQLiteManager._();

  static late Database _database;
  Database get database => _database;

  static Future initialize() async {
    if (kIsWeb) {
      return;
    }
    _database = await initializeDatabaseFromDbFile(
      'bringer_cam',
      'camera_media.db',
    );
  }

  /// START READ QUERY CALLS

  Future<List<FetchImagesToUploadRow>> fetchImagesToUpload() =>
      performFetchImagesToUpload(_database);

  Future<List<ReadUploadedImagesRow>> readUploadedImages() =>
      performReadUploadedImages(_database);

  Future<List<ReadImagesToUploadRow>> readImagesToUpload() =>
      performReadImagesToUpload(_database);

  Future<List<ShowLocalImagesRow>> showLocalImages() =>
      performShowLocalImages(_database);

  /// END READ QUERY CALLS

  /// START UPDATE QUERY CALLS

  Future insertImage({
    String? path,
    String? ownerId,
    int? unixTimestamp,
  }) =>
      performInsertImage(
        _database,
        path: path,
        ownerId: ownerId,
        unixTimestamp: unixTimestamp,
      );

  Future deleteImage({
    String? path,
  }) =>
      performDeleteImage(
        _database,
        path: path,
      );

  /// END UPDATE QUERY CALLS
}
