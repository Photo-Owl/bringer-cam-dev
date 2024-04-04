import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';

class UserEventsRecord extends FirestoreRecord {
  UserEventsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "event_name" field.
  String? _eventName;
  String get eventName => _eventName ?? '';
  bool hasEventName() => _eventName != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  bool hasTimestamp() => _timestamp != null;

  // "album_id" field.
  String? _albumId;
  String get albumId => _albumId ?? '';
  bool hasAlbumId() => _albumId != null;

  // "key" field.
  String? _key;
  String get key => _key ?? '';
  bool hasKey() => _key != null;

  // "banner_id" field.
  String? _bannerId;
  String get bannerId => _bannerId ?? '';
  bool hasBannerId() => _bannerId != null;

  void _initializeFields() {
    _eventName = snapshotData['event_name'] as String?;
    _uid = snapshotData['uid'] as String?;
    _timestamp = snapshotData['timestamp'] as DateTime?;
    _albumId = snapshotData['album_id'] as String?;
    _key = snapshotData['key'] as String?;
    _bannerId = snapshotData['banner_id'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('userEvents');

  static Stream<UserEventsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UserEventsRecord.fromSnapshot(s));

  static Future<UserEventsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UserEventsRecord.fromSnapshot(s));

  static UserEventsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UserEventsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UserEventsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UserEventsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UserEventsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UserEventsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUserEventsRecordData({
  String? eventName,
  String? uid,
  DateTime? timestamp,
  String? albumId,
  String? key,
  String? bannerId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'event_name': eventName,
      'uid': uid,
      'timestamp': timestamp,
      'album_id': albumId,
      'key': key,
      'banner_id': bannerId,
    }.withoutNulls,
  );

  return firestoreData;
}

class UserEventsRecordDocumentEquality implements Equality<UserEventsRecord> {
  const UserEventsRecordDocumentEquality();

  @override
  bool equals(UserEventsRecord? e1, UserEventsRecord? e2) {
    return e1?.eventName == e2?.eventName &&
        e1?.uid == e2?.uid &&
        e1?.timestamp == e2?.timestamp &&
        e1?.albumId == e2?.albumId &&
        e1?.key == e2?.key &&
        e1?.bannerId == e2?.bannerId;
  }

  @override
  int hash(UserEventsRecord? e) => const ListEquality().hash(
      [e?.eventName, e?.uid, e?.timestamp, e?.albumId, e?.key, e?.bannerId]);

  @override
  bool isValidKey(Object? o) => o is UserEventsRecord;
}
