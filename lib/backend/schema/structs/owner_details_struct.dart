// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class OwnerDetailsStruct extends FFFirebaseStruct {
  OwnerDetailsStruct({
    String? name,
    String? photoURL,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _photoURL = photoURL,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;
  bool hasName() => _name != null;

  // "photoURL" field.
  String? _photoURL;
  String get photoURL => _photoURL ?? '';
  set photoURL(String? val) => _photoURL = val;
  bool hasPhotoURL() => _photoURL != null;

  static OwnerDetailsStruct fromMap(Map<String, dynamic> data) =>
      OwnerDetailsStruct(
        name: data['name'] as String?,
        photoURL: data['photoURL'] as String?,
      );

  static OwnerDetailsStruct? maybeFromMap(dynamic data) => data is Map
      ? OwnerDetailsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'photoURL': _photoURL,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'photoURL': serializeParam(
          _photoURL,
          ParamType.String,
        ),
      }.withoutNulls;

  static OwnerDetailsStruct fromSerializableMap(Map<String, dynamic> data) =>
      OwnerDetailsStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        photoURL: deserializeParam(
          data['photoURL'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'OwnerDetailsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OwnerDetailsStruct &&
        name == other.name &&
        photoURL == other.photoURL;
  }

  @override
  int get hashCode => const ListEquality().hash([name, photoURL]);
}

OwnerDetailsStruct createOwnerDetailsStruct({
  String? name,
  String? photoURL,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    OwnerDetailsStruct(
      name: name,
      photoURL: photoURL,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

OwnerDetailsStruct? updateOwnerDetailsStruct(
  OwnerDetailsStruct? ownerDetails, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    ownerDetails
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addOwnerDetailsStructData(
  Map<String, dynamic> firestoreData,
  OwnerDetailsStruct? ownerDetails,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (ownerDetails == null) {
    return;
  }
  if (ownerDetails.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && ownerDetails.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final ownerDetailsData =
      getOwnerDetailsFirestoreData(ownerDetails, forFieldValue);
  final nestedData =
      ownerDetailsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = ownerDetails.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getOwnerDetailsFirestoreData(
  OwnerDetailsStruct? ownerDetails, [
  bool forFieldValue = false,
]) {
  if (ownerDetails == null) {
    return {};
  }
  final firestoreData = mapToFirestore(ownerDetails.toMap());

  // Add any Firestore field values
  ownerDetails.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getOwnerDetailsListFirestoreData(
  List<OwnerDetailsStruct>? ownerDetailss,
) =>
    ownerDetailss?.map((e) => getOwnerDetailsFirestoreData(e, true)).toList() ??
    [];
