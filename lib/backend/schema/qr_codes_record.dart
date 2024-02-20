import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';

class QrCodesRecord extends FirestoreRecord {
  QrCodesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "redirect_url" field.
  String? _redirectUrl;
  String get redirectUrl => _redirectUrl ?? '';
  bool hasRedirectUrl() => _redirectUrl != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "logo_url" field.
  String? _logoUrl;
  String get logoUrl => _logoUrl ?? '';
  bool hasLogoUrl() => _logoUrl != null;

  // "banner_url" field.
  String? _bannerUrl;
  String get bannerUrl => _bannerUrl ?? '';
  bool hasBannerUrl() => _bannerUrl != null;

  void _initializeFields() {
    _redirectUrl = snapshotData['redirect_url'] as String?;
    _id = snapshotData['id'] as String?;
    _uid = snapshotData['uid'] as String?;
    _logoUrl = snapshotData['logo_url'] as String?;
    _bannerUrl = snapshotData['banner_url'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('qrCodes');

  static Stream<QrCodesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => QrCodesRecord.fromSnapshot(s));

  static Future<QrCodesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => QrCodesRecord.fromSnapshot(s));

  static QrCodesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      QrCodesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static QrCodesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      QrCodesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'QrCodesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is QrCodesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createQrCodesRecordData({
  String? redirectUrl,
  String? id,
  String? uid,
  String? logoUrl,
  String? bannerUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'redirect_url': redirectUrl,
      'id': id,
      'uid': uid,
      'logo_url': logoUrl,
      'banner_url': bannerUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class QrCodesRecordDocumentEquality implements Equality<QrCodesRecord> {
  const QrCodesRecordDocumentEquality();

  @override
  bool equals(QrCodesRecord? e1, QrCodesRecord? e2) {
    return e1?.redirectUrl == e2?.redirectUrl &&
        e1?.id == e2?.id &&
        e1?.uid == e2?.uid &&
        e1?.logoUrl == e2?.logoUrl &&
        e1?.bannerUrl == e2?.bannerUrl;
  }

  @override
  int hash(QrCodesRecord? e) => const ListEquality()
      .hash([e?.redirectUrl, e?.id, e?.uid, e?.logoUrl, e?.bannerUrl]);

  @override
  bool isValidKey(Object? o) => o is QrCodesRecord;
}
