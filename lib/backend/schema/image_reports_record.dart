import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ImageReportsRecord extends FirestoreRecord {
  ImageReportsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "key" field.
  String? _key;
  String get key => _key ?? '';
  bool hasKey() => _key != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "reason" field.
  String? _reason;
  String get reason => _reason ?? '';
  bool hasReason() => _reason != null;

  void _initializeFields() {
    _key = snapshotData['key'] as String?;
    _uid = snapshotData['uid'] as String?;
    _reason = snapshotData['reason'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('imageReports');

  static Stream<ImageReportsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ImageReportsRecord.fromSnapshot(s));

  static Future<ImageReportsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ImageReportsRecord.fromSnapshot(s));

  static ImageReportsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ImageReportsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ImageReportsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ImageReportsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ImageReportsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ImageReportsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createImageReportsRecordData({
  String? key,
  String? uid,
  String? reason,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'key': key,
      'uid': uid,
      'reason': reason,
    }.withoutNulls,
  );

  return firestoreData;
}

class ImageReportsRecordDocumentEquality
    implements Equality<ImageReportsRecord> {
  const ImageReportsRecordDocumentEquality();

  @override
  bool equals(ImageReportsRecord? e1, ImageReportsRecord? e2) {
    return e1?.key == e2?.key && e1?.uid == e2?.uid && e1?.reason == e2?.reason;
  }

  @override
  int hash(ImageReportsRecord? e) =>
      const ListEquality().hash([e?.key, e?.uid, e?.reason]);

  @override
  bool isValidKey(Object? o) => o is ImageReportsRecord;
}
