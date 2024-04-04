// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TimelineItemStruct extends FFFirebaseStruct {
  TimelineItemStruct({
    List<ImageModelStruct>? images,
    List<String>? owners,
    String? date,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _images = images,
        _owners = owners,
        _date = date,
        super(firestoreUtilData);

  // "images" field.
  List<ImageModelStruct>? _images;
  List<ImageModelStruct> get images => _images ?? const [];
  set images(List<ImageModelStruct>? val) => _images = val;
  void updateImages(Function(List<ImageModelStruct>) updateFn) =>
      updateFn(_images ??= []);
  bool hasImages() => _images != null;

  // "owners" field.
  List<String>? _owners;
  List<String> get owners => _owners ?? const [];
  set owners(List<String>? val) => _owners = val;
  void updateOwners(Function(List<String>) updateFn) =>
      updateFn(_owners ??= []);
  bool hasOwners() => _owners != null;

  // "date" field.
  String? _date;
  String get date => _date ?? '';
  set date(String? val) => _date = val;
  bool hasDate() => _date != null;

  static TimelineItemStruct fromMap(Map<String, dynamic> data) =>
      TimelineItemStruct(
        images: getStructList(
          data['images'],
          ImageModelStruct.fromMap,
        ),
        owners: getDataList(data['owners']),
        date: data['date'] as String?,
      );

  static TimelineItemStruct? maybeFromMap(dynamic data) => data is Map
      ? TimelineItemStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'images': _images?.map((e) => e.toMap()).toList(),
        'owners': _owners,
        'date': _date,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'images': serializeParam(
          _images,
          ParamType.DataStruct,
          true,
        ),
        'owners': serializeParam(
          _owners,
          ParamType.String,
          true,
        ),
        'date': serializeParam(
          _date,
          ParamType.String,
        ),
      }.withoutNulls;

  static TimelineItemStruct fromSerializableMap(Map<String, dynamic> data) =>
      TimelineItemStruct(
        images: deserializeStructParam<ImageModelStruct>(
          data['images'],
          ParamType.DataStruct,
          true,
          structBuilder: ImageModelStruct.fromSerializableMap,
        ),
        owners: deserializeParam<String>(
          data['owners'],
          ParamType.String,
          true,
        ),
        date: deserializeParam(
          data['date'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TimelineItemStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is TimelineItemStruct &&
        listEquality.equals(images, other.images) &&
        listEquality.equals(owners, other.owners) &&
        date == other.date;
  }

  @override
  int get hashCode => const ListEquality().hash([images, owners, date]);
}

TimelineItemStruct createTimelineItemStruct({
  String? date,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TimelineItemStruct(
      date: date,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TimelineItemStruct? updateTimelineItemStruct(
  TimelineItemStruct? timelineItem, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    timelineItem
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTimelineItemStructData(
  Map<String, dynamic> firestoreData,
  TimelineItemStruct? timelineItem,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (timelineItem == null) {
    return;
  }
  if (timelineItem.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && timelineItem.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final timelineItemData =
      getTimelineItemFirestoreData(timelineItem, forFieldValue);
  final nestedData =
      timelineItemData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = timelineItem.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTimelineItemFirestoreData(
  TimelineItemStruct? timelineItem, [
  bool forFieldValue = false,
]) {
  if (timelineItem == null) {
    return {};
  }
  final firestoreData = mapToFirestore(timelineItem.toMap());

  // Add any Firestore field values
  timelineItem.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTimelineItemListFirestoreData(
  List<TimelineItemStruct>? timelineItems,
) =>
    timelineItems?.map((e) => getTimelineItemFirestoreData(e, true)).toList() ??
    [];
