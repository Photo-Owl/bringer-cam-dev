import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UploadsRecord extends FirestoreRecord {
  UploadsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "upload_url" field.
  String? _uploadUrl;
  String get uploadUrl => _uploadUrl ?? '';
  bool hasUploadUrl() => _uploadUrl != null;

  // "owner_id" field.
  String? _ownerId;
  String get ownerId => _ownerId ?? '';
  bool hasOwnerId() => _ownerId != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  bool hasImageUrl() => _imageUrl != null;

  // "error" field.
  String? _error;
  String get error => _error ?? '';
  bool hasError() => _error != null;

  // "key" field.
  String? _key;
  String get key => _key ?? '';
  bool hasKey() => _key != null;

  // "bucket" field.
  String? _bucket;
  String get bucket => _bucket ?? '';
  bool hasBucket() => _bucket != null;

  // "found_all_faces" field.
  bool? _foundAllFaces;
  bool get foundAllFaces => _foundAllFaces ?? false;
  bool hasFoundAllFaces() => _foundAllFaces != null;

  // "num_faces" field.
  int? _numFaces;
  int get numFaces => _numFaces ?? 0;
  bool hasNumFaces() => _numFaces != null;

  // "faces" field.
  List<String>? _faces;
  List<String> get faces => _faces ?? const [];
  bool hasFaces() => _faces != null;

  // "likes" field.
  int? _likes;
  int get likes => _likes ?? 0;
  bool hasLikes() => _likes != null;

  // "liked_users" field.
  List<DocumentReference>? _likedUsers;
  List<DocumentReference> get likedUsers => _likedUsers ?? const [];
  bool hasLikedUsers() => _likedUsers != null;

  // "uploaded_at" field.
  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _uploadedAt;
  bool hasUploadedAt() => _uploadedAt != null;

  // "compressed_url" field.
  String? _compressedUrl;
  String get compressedUrl => _compressedUrl ?? '';
  bool hasCompressedUrl() => _compressedUrl != null;

  // "resized_image_250" field.
  String? _resizedImage250;
  String get resizedImage250 => _resizedImage250 ?? '';
  bool hasResizedImage250() => _resizedImage250 != null;

  // "resized_image_600" field.
  String? _resizedImage600;
  String get resizedImage600 => _resizedImage600 ?? '';
  bool hasResizedImage600() => _resizedImage600 != null;

  // "album_id" field.
  String? _albumId;
  String get albumId => _albumId ?? '';
  bool hasAlbumId() => _albumId != null;

  // "watermarked_image_500" field.
  String? _watermarkedImage500;
  String get watermarkedImage500 => _watermarkedImage500 ?? '';
  bool hasWatermarkedImage500() => _watermarkedImage500 != null;

  // "watermarked_image_resolution" field.
  String? _watermarkedImageResolution;
  String get watermarkedImageResolution => _watermarkedImageResolution ?? '';
  bool hasWatermarkedImageResolution() => _watermarkedImageResolution != null;

  // "orginal_image_resolution" field.
  String? _orginalImageResolution;
  String get orginalImageResolution => _orginalImageResolution ?? '';
  bool hasOrginalImageResolution() => _orginalImageResolution != null;

  void _initializeFields() {
    _uploadUrl = snapshotData['upload_url'] as String?;
    _ownerId = snapshotData['owner_id'] as String?;
    _imageUrl = snapshotData['image_url'] as String?;
    _error = snapshotData['error'] as String?;
    _key = snapshotData['key'] as String?;
    _bucket = snapshotData['bucket'] as String?;
    _foundAllFaces = snapshotData['found_all_faces'] as bool?;
    _numFaces = castToType<int>(snapshotData['num_faces']);
    _faces = getDataList(snapshotData['faces']);
    _likes = castToType<int>(snapshotData['likes']);
    _likedUsers = getDataList(snapshotData['liked_users']);
    _uploadedAt = snapshotData['uploaded_at'] as DateTime?;
    _compressedUrl = snapshotData['compressed_url'] as String?;
    _resizedImage250 = snapshotData['resized_image_250'] as String?;
    _resizedImage600 = snapshotData['resized_image_600'] as String?;
    _albumId = snapshotData['album_id'] as String?;
    _watermarkedImage500 = snapshotData['watermarked_image_500'] as String?;
    _watermarkedImageResolution =
        snapshotData['watermarked_image_resolution'] as String?;
    _orginalImageResolution =
        snapshotData['orginal_image_resolution'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('uploads');

  static Stream<UploadsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UploadsRecord.fromSnapshot(s));

  static Future<UploadsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UploadsRecord.fromSnapshot(s));

  static UploadsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      UploadsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UploadsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UploadsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UploadsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UploadsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUploadsRecordData({
  String? uploadUrl,
  String? ownerId,
  String? imageUrl,
  String? error,
  String? key,
  String? bucket,
  bool? foundAllFaces,
  int? numFaces,
  int? likes,
  DateTime? uploadedAt,
  String? compressedUrl,
  String? resizedImage250,
  String? resizedImage600,
  String? albumId,
  String? watermarkedImage500,
  String? watermarkedImageResolution,
  String? orginalImageResolution,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'upload_url': uploadUrl,
      'owner_id': ownerId,
      'image_url': imageUrl,
      'error': error,
      'key': key,
      'bucket': bucket,
      'found_all_faces': foundAllFaces,
      'num_faces': numFaces,
      'likes': likes,
      'uploaded_at': uploadedAt,
      'compressed_url': compressedUrl,
      'resized_image_250': resizedImage250,
      'resized_image_600': resizedImage600,
      'album_id': albumId,
      'watermarked_image_500': watermarkedImage500,
      'watermarked_image_resolution': watermarkedImageResolution,
      'orginal_image_resolution': orginalImageResolution,
    }.withoutNulls,
  );

  return firestoreData;
}

class UploadsRecordDocumentEquality implements Equality<UploadsRecord> {
  const UploadsRecordDocumentEquality();

  @override
  bool equals(UploadsRecord? e1, UploadsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.uploadUrl == e2?.uploadUrl &&
        e1?.ownerId == e2?.ownerId &&
        e1?.imageUrl == e2?.imageUrl &&
        e1?.error == e2?.error &&
        e1?.key == e2?.key &&
        e1?.bucket == e2?.bucket &&
        e1?.foundAllFaces == e2?.foundAllFaces &&
        e1?.numFaces == e2?.numFaces &&
        listEquality.equals(e1?.faces, e2?.faces) &&
        e1?.likes == e2?.likes &&
        listEquality.equals(e1?.likedUsers, e2?.likedUsers) &&
        e1?.uploadedAt == e2?.uploadedAt &&
        e1?.compressedUrl == e2?.compressedUrl &&
        e1?.resizedImage250 == e2?.resizedImage250 &&
        e1?.resizedImage600 == e2?.resizedImage600 &&
        e1?.albumId == e2?.albumId &&
        e1?.watermarkedImage500 == e2?.watermarkedImage500 &&
        e1?.watermarkedImageResolution == e2?.watermarkedImageResolution &&
        e1?.orginalImageResolution == e2?.orginalImageResolution;
  }

  @override
  int hash(UploadsRecord? e) => const ListEquality().hash([
        e?.uploadUrl,
        e?.ownerId,
        e?.imageUrl,
        e?.error,
        e?.key,
        e?.bucket,
        e?.foundAllFaces,
        e?.numFaces,
        e?.faces,
        e?.likes,
        e?.likedUsers,
        e?.uploadedAt,
        e?.compressedUrl,
        e?.resizedImage250,
        e?.resizedImage600,
        e?.albumId,
        e?.watermarkedImage500,
        e?.watermarkedImageResolution,
        e?.orginalImageResolution
      ]);

  @override
  bool isValidKey(Object? o) => o is UploadsRecord;
}
