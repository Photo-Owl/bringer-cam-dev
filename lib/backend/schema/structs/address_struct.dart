// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AddressStruct extends FFFirebaseStruct {
  AddressStruct({
    String? contactName,
    String? contactPhoneNumber,
    String? addressline1,
    String? addressline2,
    String? doorNo,
    String? state,
    String? pincode,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _contactName = contactName,
        _contactPhoneNumber = contactPhoneNumber,
        _addressline1 = addressline1,
        _addressline2 = addressline2,
        _doorNo = doorNo,
        _state = state,
        _pincode = pincode,
        super(firestoreUtilData);

  // "ContactName" field.
  String? _contactName;
  String get contactName => _contactName ?? '';
  set contactName(String? val) => _contactName = val;
  bool hasContactName() => _contactName != null;

  // "ContactPhoneNumber" field.
  String? _contactPhoneNumber;
  String get contactPhoneNumber => _contactPhoneNumber ?? '';
  set contactPhoneNumber(String? val) => _contactPhoneNumber = val;
  bool hasContactPhoneNumber() => _contactPhoneNumber != null;

  // "Addressline1" field.
  String? _addressline1;
  String get addressline1 => _addressline1 ?? '';
  set addressline1(String? val) => _addressline1 = val;
  bool hasAddressline1() => _addressline1 != null;

  // "Addressline2" field.
  String? _addressline2;
  String get addressline2 => _addressline2 ?? '';
  set addressline2(String? val) => _addressline2 = val;
  bool hasAddressline2() => _addressline2 != null;

  // "DoorNo" field.
  String? _doorNo;
  String get doorNo => _doorNo ?? '';
  set doorNo(String? val) => _doorNo = val;
  bool hasDoorNo() => _doorNo != null;

  // "State" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;
  bool hasState() => _state != null;

  // "pincode" field.
  String? _pincode;
  String get pincode => _pincode ?? '';
  set pincode(String? val) => _pincode = val;
  bool hasPincode() => _pincode != null;

  static AddressStruct fromMap(Map<String, dynamic> data) => AddressStruct(
        contactName: data['ContactName'] as String?,
        contactPhoneNumber: data['ContactPhoneNumber'] as String?,
        addressline1: data['Addressline1'] as String?,
        addressline2: data['Addressline2'] as String?,
        doorNo: data['DoorNo'] as String?,
        state: data['State'] as String?,
        pincode: data['pincode'] as String?,
      );

  static AddressStruct? maybeFromMap(dynamic data) =>
      data is Map ? AddressStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'ContactName': _contactName,
        'ContactPhoneNumber': _contactPhoneNumber,
        'Addressline1': _addressline1,
        'Addressline2': _addressline2,
        'DoorNo': _doorNo,
        'State': _state,
        'pincode': _pincode,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ContactName': serializeParam(
          _contactName,
          ParamType.String,
        ),
        'ContactPhoneNumber': serializeParam(
          _contactPhoneNumber,
          ParamType.String,
        ),
        'Addressline1': serializeParam(
          _addressline1,
          ParamType.String,
        ),
        'Addressline2': serializeParam(
          _addressline2,
          ParamType.String,
        ),
        'DoorNo': serializeParam(
          _doorNo,
          ParamType.String,
        ),
        'State': serializeParam(
          _state,
          ParamType.String,
        ),
        'pincode': serializeParam(
          _pincode,
          ParamType.String,
        ),
      }.withoutNulls;

  static AddressStruct fromSerializableMap(Map<String, dynamic> data) =>
      AddressStruct(
        contactName: deserializeParam(
          data['ContactName'],
          ParamType.String,
          false,
        ),
        contactPhoneNumber: deserializeParam(
          data['ContactPhoneNumber'],
          ParamType.String,
          false,
        ),
        addressline1: deserializeParam(
          data['Addressline1'],
          ParamType.String,
          false,
        ),
        addressline2: deserializeParam(
          data['Addressline2'],
          ParamType.String,
          false,
        ),
        doorNo: deserializeParam(
          data['DoorNo'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['State'],
          ParamType.String,
          false,
        ),
        pincode: deserializeParam(
          data['pincode'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AddressStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AddressStruct &&
        contactName == other.contactName &&
        contactPhoneNumber == other.contactPhoneNumber &&
        addressline1 == other.addressline1 &&
        addressline2 == other.addressline2 &&
        doorNo == other.doorNo &&
        state == other.state &&
        pincode == other.pincode;
  }

  @override
  int get hashCode => const ListEquality().hash([
        contactName,
        contactPhoneNumber,
        addressline1,
        addressline2,
        doorNo,
        state,
        pincode
      ]);
}

AddressStruct createAddressStruct({
  String? contactName,
  String? contactPhoneNumber,
  String? addressline1,
  String? addressline2,
  String? doorNo,
  String? state,
  String? pincode,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AddressStruct(
      contactName: contactName,
      contactPhoneNumber: contactPhoneNumber,
      addressline1: addressline1,
      addressline2: addressline2,
      doorNo: doorNo,
      state: state,
      pincode: pincode,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AddressStruct? updateAddressStruct(
  AddressStruct? address, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    address
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAddressStructData(
  Map<String, dynamic> firestoreData,
  AddressStruct? address,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (address == null) {
    return;
  }
  if (address.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && address.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final addressData = getAddressFirestoreData(address, forFieldValue);
  final nestedData = addressData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = address.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAddressFirestoreData(
  AddressStruct? address, [
  bool forFieldValue = false,
]) {
  if (address == null) {
    return {};
  }
  final firestoreData = mapToFirestore(address.toMap());

  // Add any Firestore field values
  address.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAddressListFirestoreData(
  List<AddressStruct>? addresss,
) =>
    addresss?.map((e) => getAddressFirestoreData(e, true)).toList() ?? [];
