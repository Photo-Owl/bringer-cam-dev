import 'package:sqflite/sqflite.dart';

/// BEGIN INSERTIMAGE
Future performInsertImage(
  Database database, {
  String? path,
  String? ownerId,
  int? unixTimestamp,
}) {
  final query = '''
INSERT INTO Images ("path", "owner", "unix_timestamp", "is_uploaded", "is_uploading")
  VALUES('$path', '$ownerId', $unixTimestamp, 0, 0);
''';
  return database.rawQuery(query);
}

/// END INSERTIMAGE

/// BEGIN DELETEIMAGE
Future performDeleteImage(
  Database database, {
  String? path,
}) {
  final query = '''
DELETE FROM Images WHERE "path" = '$path';
''';
  return database.rawQuery(query);
}

/// END DELETEIMAGE
