// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ImageModelStruct extends FFFirebaseStruct {
  ImageModelStruct({
    DateTime? timestamp,
    String? id,
    String? imageUrl,
    bool? isUploading,
    bool? isLocal,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _timestamp = timestamp,
        _id = id,
        _imageUrl = imageUrl,
        _isUploading = isUploading,
        _isLocal = isLocal,
        super(firestoreUtilData);

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  set timestamp(DateTime? val) => _timestamp = val;
  bool hasTimestamp() => _timestamp != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;
  bool hasId() => _id != null;

  // "image_url" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;
  bool hasImageUrl() => _imageUrl != null;

  // "is_uploading" field.
  bool? _isUploading;
  bool get isUploading => _isUploading ?? false;
  set isUploading(bool? val) => _isUploading = val;
  bool hasIsUploading() => _isUploading != null;

  // "is_local" field.
  bool? _isLocal;
  bool get isLocal => _isLocal ?? false;
  set isLocal(bool? val) => _isLocal = val;
  bool hasIsLocal() => _isLocal != null;

  static ImageModelStruct fromMap(Map<String, dynamic> data) =>
      ImageModelStruct(
        timestamp: data['timestamp'] as DateTime?,
        id: data['id'] as String?,
        imageUrl: data['image_url'] as String?,
        isUploading: data['is_uploading'] as bool?,
        isLocal: data['is_local'] as bool?,
      );

  static ImageModelStruct? maybeFromMap(dynamic data) => data is Map
      ? ImageModelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'timestamp': _timestamp,
        'id': _id,
        'image_url': _imageUrl,
        'is_uploading': _isUploading,
        'is_local': _isLocal,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'timestamp': serializeParam(
          _timestamp,
          ParamType.DateTime,
        ),
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'image_url': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'is_uploading': serializeParam(
          _isUploading,
          ParamType.bool,
        ),
        'is_local': serializeParam(
          _isLocal,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ImageModelStruct fromSerializableMap(Map<String, dynamic> data) =>
      ImageModelStruct(
        timestamp: deserializeParam(
          data['timestamp'],
          ParamType.DateTime,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['image_url'],
          ParamType.String,
          false,
        ),
        isUploading: deserializeParam(
          data['is_uploading'],
          ParamType.bool,
          false,
        ),
        isLocal: deserializeParam(
          data['is_local'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ImageModelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ImageModelStruct &&
        timestamp == other.timestamp &&
        id == other.id &&
        imageUrl == other.imageUrl &&
        isUploading == other.isUploading &&
        isLocal == other.isLocal;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([timestamp, id, imageUrl, isUploading, isLocal]);
}

ImageModelStruct createImageModelStruct({
  DateTime? timestamp,
  String? id,
  String? imageUrl,
  bool? isUploading,
  bool? isLocal,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ImageModelStruct(
      timestamp: timestamp,
      id: id,
      imageUrl: imageUrl,
      isUploading: isUploading,
      isLocal: isLocal,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ImageModelStruct? updateImageModelStruct(
  ImageModelStruct? imageModel, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    imageModel
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addImageModelStructData(
  Map<String, dynamic> firestoreData,
  ImageModelStruct? imageModel,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (imageModel == null) {
    return;
  }
  if (imageModel.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && imageModel.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final imageModelData = getImageModelFirestoreData(imageModel, forFieldValue);
  final nestedData = imageModelData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = imageModel.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getImageModelFirestoreData(
  ImageModelStruct? imageModel, [
  bool forFieldValue = false,
]) {
  if (imageModel == null) {
    return {};
  }
  final firestoreData = mapToFirestore(imageModel.toMap());

  // Add any Firestore field values
  imageModel.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getImageModelListFirestoreData(
  List<ImageModelStruct>? imageModels,
) =>
    imageModels?.map((e) => getImageModelFirestoreData(e, true)).toList() ?? [];
