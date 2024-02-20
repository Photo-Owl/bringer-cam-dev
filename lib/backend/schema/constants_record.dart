import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConstantsRecord extends FirestoreRecord {
  ConstantsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "website_build_number" field.
  int? _websiteBuildNumber;
  int get websiteBuildNumber => _websiteBuildNumber ?? 0;
  bool hasWebsiteBuildNumber() => _websiteBuildNumber != null;

  // "allow_new_users" field.
  bool? _allowNewUsers;
  bool get allowNewUsers => _allowNewUsers ?? false;
  bool hasAllowNewUsers() => _allowNewUsers != null;

  void _initializeFields() {
    _websiteBuildNumber = castToType<int>(snapshotData['website_build_number']);
    _allowNewUsers = snapshotData['allow_new_users'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Constants');

  static Stream<ConstantsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ConstantsRecord.fromSnapshot(s));

  static Future<ConstantsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ConstantsRecord.fromSnapshot(s));

  static ConstantsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ConstantsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ConstantsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ConstantsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ConstantsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ConstantsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createConstantsRecordData({
  int? websiteBuildNumber,
  bool? allowNewUsers,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'website_build_number': websiteBuildNumber,
      'allow_new_users': allowNewUsers,
    }.withoutNulls,
  );

  return firestoreData;
}

class ConstantsRecordDocumentEquality implements Equality<ConstantsRecord> {
  const ConstantsRecordDocumentEquality();

  @override
  bool equals(ConstantsRecord? e1, ConstantsRecord? e2) {
    return e1?.websiteBuildNumber == e2?.websiteBuildNumber &&
        e1?.allowNewUsers == e2?.allowNewUsers;
  }

  @override
  int hash(ConstantsRecord? e) =>
      const ListEquality().hash([e?.websiteBuildNumber, e?.allowNewUsers]);

  @override
  bool isValidKey(Object? o) => o is ConstantsRecord;
}
