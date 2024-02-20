import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "refrence_photo_bucket" field.
  String? _refrencePhotoBucket;
  String get refrencePhotoBucket => _refrencePhotoBucket ?? '';
  bool hasRefrencePhotoBucket() => _refrencePhotoBucket != null;

  // "refrence_photo_key" field.
  String? _refrencePhotoKey;
  String get refrencePhotoKey => _refrencePhotoKey ?? '';
  bool hasRefrencePhotoKey() => _refrencePhotoKey != null;

  // "face_id" field.
  String? _faceId;
  String get faceId => _faceId ?? '';
  bool hasFaceId() => _faceId != null;

  // "progress_level" field.
  double? _progressLevel;
  double get progressLevel => _progressLevel ?? 0.0;
  bool hasProgressLevel() => _progressLevel != null;

  // "upload_progress" field.
  double? _uploadProgress;
  double get uploadProgress => _uploadProgress ?? 0.0;
  bool hasUploadProgress() => _uploadProgress != null;

  // "is_business_account" field.
  bool? _isBusinessAccount;
  bool get isBusinessAccount => _isBusinessAccount ?? false;
  bool hasIsBusinessAccount() => _isBusinessAccount != null;

  // "last_open_at" field.
  DateTime? _lastOpenAt;
  DateTime? get lastOpenAt => _lastOpenAt;
  bool hasLastOpenAt() => _lastOpenAt != null;

  // "last_image_expanded_at" field.
  DateTime? _lastImageExpandedAt;
  DateTime? get lastImageExpandedAt => _lastImageExpandedAt;
  bool hasLastImageExpandedAt() => _lastImageExpandedAt != null;

  // "next_completion_reminder_at" field.
  DateTime? _nextCompletionReminderAt;
  DateTime? get nextCompletionReminderAt => _nextCompletionReminderAt;
  bool hasNextCompletionReminderAt() => _nextCompletionReminderAt != null;

  // "last_downloaded_at" field.
  DateTime? _lastDownloadedAt;
  DateTime? get lastDownloadedAt => _lastDownloadedAt;
  bool hasLastDownloadedAt() => _lastDownloadedAt != null;

  // "allow_photo_album_print" field.
  bool? _allowPhotoAlbumPrint;
  bool get allowPhotoAlbumPrint => _allowPhotoAlbumPrint ?? false;
  bool hasAllowPhotoAlbumPrint() => _allowPhotoAlbumPrint != null;

  // "is_google_login" field.
  bool? _isGoogleLogin;
  bool get isGoogleLogin => _isGoogleLogin ?? false;
  bool hasIsGoogleLogin() => _isGoogleLogin != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _refrencePhotoBucket = snapshotData['refrence_photo_bucket'] as String?;
    _refrencePhotoKey = snapshotData['refrence_photo_key'] as String?;
    _faceId = snapshotData['face_id'] as String?;
    _progressLevel = castToType<double>(snapshotData['progress_level']);
    _uploadProgress = castToType<double>(snapshotData['upload_progress']);
    _isBusinessAccount = snapshotData['is_business_account'] as bool?;
    _lastOpenAt = snapshotData['last_open_at'] as DateTime?;
    _lastImageExpandedAt = snapshotData['last_image_expanded_at'] as DateTime?;
    _nextCompletionReminderAt =
        snapshotData['next_completion_reminder_at'] as DateTime?;
    _lastDownloadedAt = snapshotData['last_downloaded_at'] as DateTime?;
    _allowPhotoAlbumPrint = snapshotData['allow_photo_album_print'] as bool?;
    _isGoogleLogin = snapshotData['is_google_login'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  String? refrencePhotoBucket,
  String? refrencePhotoKey,
  String? faceId,
  double? progressLevel,
  double? uploadProgress,
  bool? isBusinessAccount,
  DateTime? lastOpenAt,
  DateTime? lastImageExpandedAt,
  DateTime? nextCompletionReminderAt,
  DateTime? lastDownloadedAt,
  bool? allowPhotoAlbumPrint,
  bool? isGoogleLogin,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'refrence_photo_bucket': refrencePhotoBucket,
      'refrence_photo_key': refrencePhotoKey,
      'face_id': faceId,
      'progress_level': progressLevel,
      'upload_progress': uploadProgress,
      'is_business_account': isBusinessAccount,
      'last_open_at': lastOpenAt,
      'last_image_expanded_at': lastImageExpandedAt,
      'next_completion_reminder_at': nextCompletionReminderAt,
      'last_downloaded_at': lastDownloadedAt,
      'allow_photo_album_print': allowPhotoAlbumPrint,
      'is_google_login': isGoogleLogin,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.refrencePhotoBucket == e2?.refrencePhotoBucket &&
        e1?.refrencePhotoKey == e2?.refrencePhotoKey &&
        e1?.faceId == e2?.faceId &&
        e1?.progressLevel == e2?.progressLevel &&
        e1?.uploadProgress == e2?.uploadProgress &&
        e1?.isBusinessAccount == e2?.isBusinessAccount &&
        e1?.lastOpenAt == e2?.lastOpenAt &&
        e1?.lastImageExpandedAt == e2?.lastImageExpandedAt &&
        e1?.nextCompletionReminderAt == e2?.nextCompletionReminderAt &&
        e1?.lastDownloadedAt == e2?.lastDownloadedAt &&
        e1?.allowPhotoAlbumPrint == e2?.allowPhotoAlbumPrint &&
        e1?.isGoogleLogin == e2?.isGoogleLogin;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.refrencePhotoBucket,
        e?.refrencePhotoKey,
        e?.faceId,
        e?.progressLevel,
        e?.uploadProgress,
        e?.isBusinessAccount,
        e?.lastOpenAt,
        e?.lastImageExpandedAt,
        e?.nextCompletionReminderAt,
        e?.lastDownloadedAt,
        e?.allowPhotoAlbumPrint,
        e?.isGoogleLogin
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
