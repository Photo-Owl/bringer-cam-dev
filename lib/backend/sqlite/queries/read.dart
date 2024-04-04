import '/backend/sqlite/queries/sqlite_row.dart';
import 'package:sqflite/sqflite.dart';

Future<List<T>> _readQuery<T>(
  Database database,
  String query,
  T Function(Map<String, dynamic>) create,
) =>
    database.rawQuery(query).then((r) => r.map((e) => create(e)).toList());

/// BEGIN FETCHIMAGESTOUPLOAD
Future<List<FetchImagesToUploadRow>> performFetchImagesToUpload(
  Database database, {
  String? ownerId,
}) {
  final query = '''
SELECT "path", "unix_timestamp" AS "unixTimestamp", "is_uploading" AS "isUploading"  FROM Images
  WHERE is_uploaded = 0
  AND owner = '${ownerId}'
  ORDER BY unix_timestamp ASC;
''';
  return _readQuery(database, query, (d) => FetchImagesToUploadRow(d));
}

class FetchImagesToUploadRow extends SqliteRow {
  FetchImagesToUploadRow(Map<String, dynamic> data) : super(data);

  String get path => data['path'] as String;
  int? get unixTimestamp => data['unixTimestamp'] as int?;
  int? get isUploading => data['isUploading'] as int?;
}

/// END FETCHIMAGESTOUPLOAD

/// BEGIN READUPLOADEDIMAGES
Future<List<ReadUploadedImagesRow>> performReadUploadedImages(
  Database database, {
  String? ownerId,
}) {
  final query = '''
SELECT "path" FROM Images
  WHERE owner = '${ownerId}'
  AND is_uploaded = 1
  ORDER BY unix_timestamp DESC;
''';
  return _readQuery(database, query, (d) => ReadUploadedImagesRow(d));
}

class ReadUploadedImagesRow extends SqliteRow {
  ReadUploadedImagesRow(Map<String, dynamic> data) : super(data);

  String get path => data['path'] as String;
}

/// END READUPLOADEDIMAGES

/// BEGIN READIMAGESTOUPLOAD
Future<List<ReadImagesToUploadRow>> performReadImagesToUpload(
  Database database, {
  String? ownerId,
}) {
  final query = '''
SELECT "path", "unix_timestamp", "is_uploading" FROM Images
  WHERE is_uploaded = 0
  AND owner = '${ownerId}'
  ORDER BY unix_timestamp DESC;;
''';
  return _readQuery(database, query, (d) => ReadImagesToUploadRow(d));
}

class ReadImagesToUploadRow extends SqliteRow {
  ReadImagesToUploadRow(Map<String, dynamic> data) : super(data);

  String get path => data['path'] as String;
  int? get unixTimestamp => data['unixTimestamp'] as int?;
  int? get isUploading => data['isUploading'] as int?;
}

/// END READIMAGESTOUPLOAD

/// BEGIN SHOWLOCALIMAGES
Future<List<ShowLocalImagesRow>> performShowLocalImages(
  Database database, {
  String? ownerId,
}) {
  final query = '''
SELECT "path", "unix_timestamp" AS "timestamp","is_uploading" AS "isUploading" FROM Images
  WHERE is_uploaded = 0
  AND owner = '${ownerId}'
  ORDER BY unix_timestamp ASC;
''';
  return _readQuery(database, query, (d) => ShowLocalImagesRow(d));
}

class ShowLocalImagesRow extends SqliteRow {
  ShowLocalImagesRow(Map<String, dynamic> data) : super(data);

  String get path => data['path'] as String;
  int? get timestamp => data['timestamp'] as int?;
  int get isUploading => data['isUploading'] as int;
}

/// END SHOWLOCALIMAGES
