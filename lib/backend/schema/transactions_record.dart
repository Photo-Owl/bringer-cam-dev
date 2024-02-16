import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';

class TransactionsRecord extends FirestoreRecord {
  TransactionsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  // "longurl" field.
  String? _longurl;
  String get longurl => _longurl ?? '';
  bool hasLongurl() => _longurl != null;

  void _initializeFields() {
    _status = snapshotData['status'] as String?;
    _id = snapshotData['id'] as String?;
    _longurl = snapshotData['longurl'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('transactions');

  static Stream<TransactionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => TransactionsRecord.fromSnapshot(s));

  static Future<TransactionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => TransactionsRecord.fromSnapshot(s));

  static TransactionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      TransactionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static TransactionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      TransactionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'TransactionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is TransactionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createTransactionsRecordData({
  String? status,
  String? id,
  String? longurl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'status': status,
      'id': id,
      'longurl': longurl,
    }.withoutNulls,
  );

  return firestoreData;
}

class TransactionsRecordDocumentEquality
    implements Equality<TransactionsRecord> {
  const TransactionsRecordDocumentEquality();

  @override
  bool equals(TransactionsRecord? e1, TransactionsRecord? e2) {
    return e1?.status == e2?.status &&
        e1?.id == e2?.id &&
        e1?.longurl == e2?.longurl;
  }

  @override
  int hash(TransactionsRecord? e) =>
      const ListEquality().hash([e?.status, e?.id, e?.longurl]);

  @override
  bool isValidKey(Object? o) => o is TransactionsRecord;
}
