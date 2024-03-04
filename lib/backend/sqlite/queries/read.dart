import '/backend/sqlite/queries/sqlite_row.dart';
import 'package:sqflite/sqflite.dart';

Future<List<T>> _readQuery<T>(
  Database database,
  String query,
  T Function(Map<String, dynamic>) create,
) =>
    database.rawQuery(query).then((r) => r.map((e) => create(e)).toList());

/// BEGIN READIMAGESTOUPLOAD
Future<List<ReadImagesToUploadRow>> performReadImagesToUpload(
  Database database, {
  String? ownerId,
}) {
  final query = '''
SELECT "path", "is_uploading" FROM Images
  WHERE owner = '$ownerId'
  AND is_uploaded = 0
  ORDER BY unix_timestamp DESC;
''';
  return _readQuery(database, query, (d) => ReadImagesToUploadRow(d));
}

class ReadImagesToUploadRow extends SqliteRow {
  ReadImagesToUploadRow(super.data);

  String get path => data['path'] as String;
  bool get isUploading => data['isUploading'] as bool;
}

/// END READIMAGESTOUPLOAD

/// BEGIN FETCHIMAGESTOUPLOAD
Future<List<FetchImagesToUploadRow>> performFetchImagesToUpload(
  Database database, {
  String? ownerId,
}) {
  final query = '''
SELECT "path", "unix_timestamp" FROM Images
  WHERE is_uploaded == 0
  AND owner = '$ownerId'
  ORDER BY unix_timestamp ASC;
''';
  return _readQuery(database, query, (d) => FetchImagesToUploadRow(d));
}

class FetchImagesToUploadRow extends SqliteRow {
  FetchImagesToUploadRow(super.data);

  String get path => data['path'] as String;
  int? get unixTimestamp => data['unixTimestamp'] as int?;
}

/// END FETCHIMAGESTOUPLOAD

/// BEGIN READUPLOADEDIMAGES
Future<List<ReadUploadedImagesRow>> performReadUploadedImages(
  Database database, {
  String? ownerId,
}) {
  final query = '''
SELECT "path" FROM Images
  WHERE owner = '$ownerId'
  AND is_uploaded = 1
  ORDER BY unix_timestamp DESC;
''';
  return _readQuery(database, query, (d) => ReadUploadedImagesRow(d));
}

class ReadUploadedImagesRow extends SqliteRow {
  ReadUploadedImagesRow(super.data);

  String get path => data['path'] as String;
}

/// END READUPLOADEDIMAGES
