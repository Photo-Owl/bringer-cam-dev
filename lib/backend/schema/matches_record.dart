import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MatchesRecord extends FirestoreRecord {
  MatchesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "key" field.
  String? _key;
  String get key => _key ?? '';
  bool hasKey() => _key != null;

  // "external_image_id" field.
  String? _externalImageId;
  String get externalImageId => _externalImageId ?? '';
  bool hasExternalImageId() => _externalImageId != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "face_id" field.
  String? _faceId;
  String get faceId => _faceId ?? '';
  bool hasFaceId() => _faceId != null;

  // "is_matched" field.
  bool? _isMatched;
  bool get isMatched => _isMatched ?? false;
  bool hasIsMatched() => _isMatched != null;

  // "uploaded_at" field.
  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _uploadedAt;
  bool hasUploadedAt() => _uploadedAt != null;

  void _initializeFields() {
    _key = snapshotData['key'] as String?;
    _externalImageId = snapshotData['external_image_id'] as String?;
    _uid = snapshotData['uid'] as String?;
    _faceId = snapshotData['face_id'] as String?;
    _isMatched = snapshotData['is_matched'] as bool?;
    _uploadedAt = snapshotData['uploaded_at'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('matches');

  static Stream<MatchesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => MatchesRecord.fromSnapshot(s));

  static Future<MatchesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => MatchesRecord.fromSnapshot(s));

  static MatchesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      MatchesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static MatchesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      MatchesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'MatchesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is MatchesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createMatchesRecordData({
  String? key,
  String? externalImageId,
  String? uid,
  String? faceId,
  bool? isMatched,
  DateTime? uploadedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'key': key,
      'external_image_id': externalImageId,
      'uid': uid,
      'face_id': faceId,
      'is_matched': isMatched,
      'uploaded_at': uploadedAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class MatchesRecordDocumentEquality implements Equality<MatchesRecord> {
  const MatchesRecordDocumentEquality();

  @override
  bool equals(MatchesRecord? e1, MatchesRecord? e2) {
    return e1?.key == e2?.key &&
        e1?.externalImageId == e2?.externalImageId &&
        e1?.uid == e2?.uid &&
        e1?.faceId == e2?.faceId &&
        e1?.isMatched == e2?.isMatched &&
        e1?.uploadedAt == e2?.uploadedAt;
  }

  @override
  int hash(MatchesRecord? e) => const ListEquality().hash([
        e?.key,
        e?.externalImageId,
        e?.uid,
        e?.faceId,
        e?.isMatched,
        e?.uploadedAt
      ]);

  @override
  bool isValidKey(Object? o) => o is MatchesRecord;
}
