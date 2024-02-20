import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BannersRecord extends FirestoreRecord {
  BannersRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "click_count" field.
  int? _clickCount;
  int get clickCount => _clickCount ?? 0;
  bool hasClickCount() => _clickCount != null;

  // "banner_id" field.
  String? _bannerId;
  String get bannerId => _bannerId ?? '';
  bool hasBannerId() => _bannerId != null;

  // "button_text" field.
  String? _buttonText;
  String get buttonText => _buttonText ?? '';
  bool hasButtonText() => _buttonText != null;

  // "banner_text" field.
  String? _bannerText;
  String get bannerText => _bannerText ?? '';
  bool hasBannerText() => _bannerText != null;

  void _initializeFields() {
    _clickCount = castToType<int>(snapshotData['click_count']);
    _bannerId = snapshotData['banner_id'] as String?;
    _buttonText = snapshotData['button_text'] as String?;
    _bannerText = snapshotData['banner_text'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('banners');

  static Stream<BannersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => BannersRecord.fromSnapshot(s));

  static Future<BannersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => BannersRecord.fromSnapshot(s));

  static BannersRecord fromSnapshot(DocumentSnapshot snapshot) =>
      BannersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static BannersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      BannersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'BannersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is BannersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createBannersRecordData({
  int? clickCount,
  String? bannerId,
  String? buttonText,
  String? bannerText,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'click_count': clickCount,
      'banner_id': bannerId,
      'button_text': buttonText,
      'banner_text': bannerText,
    }.withoutNulls,
  );

  return firestoreData;
}

class BannersRecordDocumentEquality implements Equality<BannersRecord> {
  const BannersRecordDocumentEquality();

  @override
  bool equals(BannersRecord? e1, BannersRecord? e2) {
    return e1?.clickCount == e2?.clickCount &&
        e1?.bannerId == e2?.bannerId &&
        e1?.buttonText == e2?.buttonText &&
        e1?.bannerText == e2?.bannerText;
  }

  @override
  int hash(BannersRecord? e) => const ListEquality()
      .hash([e?.clickCount, e?.bannerId, e?.buttonText, e?.bannerText]);

  @override
  bool isValidKey(Object? o) => o is BannersRecord;
}
