import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PremiumPhotoPurchasesRecord extends FirestoreRecord {
  PremiumPhotoPurchasesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "key" field.
  String? _key;
  String get key => _key ?? '';
  bool hasKey() => _key != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  bool hasCreatedAt() => _createdAt != null;

  // "payment_request_id" field.
  String? _paymentRequestId;
  String get paymentRequestId => _paymentRequestId ?? '';
  bool hasPaymentRequestId() => _paymentRequestId != null;

  // "payment_id" field.
  String? _paymentId;
  String get paymentId => _paymentId ?? '';
  bool hasPaymentId() => _paymentId != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  void _initializeFields() {
    _uid = snapshotData['uid'] as String?;
    _key = snapshotData['key'] as String?;
    _createdAt = snapshotData['created_at'] as String?;
    _paymentRequestId = snapshotData['payment_request_id'] as String?;
    _paymentId = snapshotData['payment_id'] as String?;
    _status = snapshotData['status'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('premiumPhotoPurchases');

  static Stream<PremiumPhotoPurchasesRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => PremiumPhotoPurchasesRecord.fromSnapshot(s));

  static Future<PremiumPhotoPurchasesRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => PremiumPhotoPurchasesRecord.fromSnapshot(s));

  static PremiumPhotoPurchasesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PremiumPhotoPurchasesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PremiumPhotoPurchasesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PremiumPhotoPurchasesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PremiumPhotoPurchasesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PremiumPhotoPurchasesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPremiumPhotoPurchasesRecordData({
  String? uid,
  String? key,
  String? createdAt,
  String? paymentRequestId,
  String? paymentId,
  String? status,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'uid': uid,
      'key': key,
      'created_at': createdAt,
      'payment_request_id': paymentRequestId,
      'payment_id': paymentId,
      'status': status,
    }.withoutNulls,
  );

  return firestoreData;
}

class PremiumPhotoPurchasesRecordDocumentEquality
    implements Equality<PremiumPhotoPurchasesRecord> {
  const PremiumPhotoPurchasesRecordDocumentEquality();

  @override
  bool equals(
      PremiumPhotoPurchasesRecord? e1, PremiumPhotoPurchasesRecord? e2) {
    return e1?.uid == e2?.uid &&
        e1?.key == e2?.key &&
        e1?.createdAt == e2?.createdAt &&
        e1?.paymentRequestId == e2?.paymentRequestId &&
        e1?.paymentId == e2?.paymentId &&
        e1?.status == e2?.status;
  }

  @override
  int hash(PremiumPhotoPurchasesRecord? e) => const ListEquality().hash([
        e?.uid,
        e?.key,
        e?.createdAt,
        e?.paymentRequestId,
        e?.paymentId,
        e?.status
      ]);

  @override
  bool isValidKey(Object? o) => o is PremiumPhotoPurchasesRecord;
}
