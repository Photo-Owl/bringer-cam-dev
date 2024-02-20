import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AlbumsRecord extends FirestoreRecord {
  AlbumsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  bool hasId() => _id != null;

  // "album_name" field.
  String? _albumName;
  String get albumName => _albumName ?? '';
  bool hasAlbumName() => _albumName != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "owner_id" field.
  String? _ownerId;
  String get ownerId => _ownerId ?? '';
  bool hasOwnerId() => _ownerId != null;

  // "is_premium" field.
  bool? _isPremium;
  bool get isPremium => _isPremium ?? false;
  bool hasIsPremium() => _isPremium != null;

  // "premium_image_cost" field.
  double? _premiumImageCost;
  double get premiumImageCost => _premiumImageCost ?? 0.0;
  bool hasPremiumImageCost() => _premiumImageCost != null;

  // "premium_image_discounted_cost" field.
  double? _premiumImageDiscountedCost;
  double get premiumImageDiscountedCost => _premiumImageDiscountedCost ?? 0.0;
  bool hasPremiumImageDiscountedCost() => _premiumImageDiscountedCost != null;

  // "expiry" field.
  DateTime? _expiry;
  DateTime? get expiry => _expiry;
  bool hasExpiry() => _expiry != null;

  void _initializeFields() {
    _id = snapshotData['id'] as String?;
    _albumName = snapshotData['album_name'] as String?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _ownerId = snapshotData['owner_id'] as String?;
    _isPremium = snapshotData['is_premium'] as bool?;
    _premiumImageCost = castToType<double>(snapshotData['premium_image_cost']);
    _premiumImageDiscountedCost =
        castToType<double>(snapshotData['premium_image_discounted_cost']);
    _expiry = snapshotData['expiry'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('albums');

  static Stream<AlbumsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AlbumsRecord.fromSnapshot(s));

  static Future<AlbumsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AlbumsRecord.fromSnapshot(s));

  static AlbumsRecord fromSnapshot(DocumentSnapshot snapshot) => AlbumsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AlbumsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AlbumsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AlbumsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AlbumsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAlbumsRecordData({
  String? id,
  String? albumName,
  DateTime? createdAt,
  String? ownerId,
  bool? isPremium,
  double? premiumImageCost,
  double? premiumImageDiscountedCost,
  DateTime? expiry,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'id': id,
      'album_name': albumName,
      'created_at': createdAt,
      'owner_id': ownerId,
      'is_premium': isPremium,
      'premium_image_cost': premiumImageCost,
      'premium_image_discounted_cost': premiumImageDiscountedCost,
      'expiry': expiry,
    }.withoutNulls,
  );

  return firestoreData;
}

class AlbumsRecordDocumentEquality implements Equality<AlbumsRecord> {
  const AlbumsRecordDocumentEquality();

  @override
  bool equals(AlbumsRecord? e1, AlbumsRecord? e2) {
    return e1?.id == e2?.id &&
        e1?.albumName == e2?.albumName &&
        e1?.createdAt == e2?.createdAt &&
        e1?.ownerId == e2?.ownerId &&
        e1?.isPremium == e2?.isPremium &&
        e1?.premiumImageCost == e2?.premiumImageCost &&
        e1?.premiumImageDiscountedCost == e2?.premiumImageDiscountedCost &&
        e1?.expiry == e2?.expiry;
  }

  @override
  int hash(AlbumsRecord? e) => const ListEquality().hash([
        e?.id,
        e?.albumName,
        e?.createdAt,
        e?.ownerId,
        e?.isPremium,
        e?.premiumImageCost,
        e?.premiumImageDiscountedCost,
        e?.expiry
      ]);

  @override
  bool isValidKey(Object? o) => o is AlbumsRecord;
}
