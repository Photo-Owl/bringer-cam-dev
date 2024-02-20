import '/backend/sqlite/queries/sqlite_row.dart';
import 'package:sqflite/sqflite.dart';

Future<List<T>> _readQuery<T>(
  Database database,
  String query,
  T Function(Map<String, dynamic>) create,
) =>
    database.rawQuery(query).then((r) => r.map((e) => create(e)).toList());

/// BEGIN READALLIMAGES
Future<List<ReadAllImagesRow>> performReadAllImages(
  Database database, {
  String? ownerId,
}) {
  final query = '''
SELECT * FROM Images WHERE owner = ? ORDER BY unix_timestamp DESC, [$ownerId]
''';
  return _readQuery(database, query, (d) => ReadAllImagesRow(d));
}

class ReadAllImagesRow extends SqliteRow {
  ReadAllImagesRow(super.data);

  String? get path => data['path'] as String?;
  String? get owner => data['owner'] as String?;
}

/// END READALLIMAGES
