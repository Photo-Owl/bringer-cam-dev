import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrdersRecord extends FirestoreRecord {
  OrdersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "order_id" field.
  String? _orderId;
  String get orderId => _orderId ?? '';
  bool hasOrderId() => _orderId != null;

  // "address" field.
  AddressStruct? _address;
  AddressStruct get address => _address ?? AddressStruct();
  bool hasAddress() => _address != null;

  // "transaction_id" field.
  String? _transactionId;
  String get transactionId => _transactionId ?? '';
  bool hasTransactionId() => _transactionId != null;

  // "selected_photos" field.
  List<String>? _selectedPhotos;
  List<String> get selectedPhotos => _selectedPhotos ?? const [];
  bool hasSelectedPhotos() => _selectedPhotos != null;

  // "product_name" field.
  String? _productName;
  String get productName => _productName ?? '';
  bool hasProductName() => _productName != null;

  // "amount_payed" field.
  String? _amountPayed;
  String get amountPayed => _amountPayed ?? '';
  bool hasAmountPayed() => _amountPayed != null;

  // "transaction_completed" field.
  bool? _transactionCompleted;
  bool get transactionCompleted => _transactionCompleted ?? false;
  bool hasTransactionCompleted() => _transactionCompleted != null;

  // "order_status" field.
  String? _orderStatus;
  String get orderStatus => _orderStatus ?? '';
  bool hasOrderStatus() => _orderStatus != null;

  // "eta" field.
  DateTime? _eta;
  DateTime? get eta => _eta;
  bool hasEta() => _eta != null;

  void _initializeFields() {
    _orderId = snapshotData['order_id'] as String?;
    _address = AddressStruct.maybeFromMap(snapshotData['address']);
    _transactionId = snapshotData['transaction_id'] as String?;
    _selectedPhotos = getDataList(snapshotData['selected_photos']);
    _productName = snapshotData['product_name'] as String?;
    _amountPayed = snapshotData['amount_payed'] as String?;
    _transactionCompleted = snapshotData['transaction_completed'] as bool?;
    _orderStatus = snapshotData['order_status'] as String?;
    _eta = snapshotData['eta'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('orders');

  static Stream<OrdersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OrdersRecord.fromSnapshot(s));

  static Future<OrdersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => OrdersRecord.fromSnapshot(s));

  static OrdersRecord fromSnapshot(DocumentSnapshot snapshot) => OrdersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OrdersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OrdersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OrdersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OrdersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOrdersRecordData({
  String? orderId,
  AddressStruct? address,
  String? transactionId,
  String? productName,
  String? amountPayed,
  bool? transactionCompleted,
  String? orderStatus,
  DateTime? eta,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'order_id': orderId,
      'address': AddressStruct().toMap(),
      'transaction_id': transactionId,
      'product_name': productName,
      'amount_payed': amountPayed,
      'transaction_completed': transactionCompleted,
      'order_status': orderStatus,
      'eta': eta,
    }.withoutNulls,
  );

  // Handle nested data for "address" field.
  addAddressStructData(firestoreData, address, 'address');

  return firestoreData;
}

class OrdersRecordDocumentEquality implements Equality<OrdersRecord> {
  const OrdersRecordDocumentEquality();

  @override
  bool equals(OrdersRecord? e1, OrdersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.orderId == e2?.orderId &&
        e1?.address == e2?.address &&
        e1?.transactionId == e2?.transactionId &&
        listEquality.equals(e1?.selectedPhotos, e2?.selectedPhotos) &&
        e1?.productName == e2?.productName &&
        e1?.amountPayed == e2?.amountPayed &&
        e1?.transactionCompleted == e2?.transactionCompleted &&
        e1?.orderStatus == e2?.orderStatus &&
        e1?.eta == e2?.eta;
  }

  @override
  int hash(OrdersRecord? e) => const ListEquality().hash([
        e?.orderId,
        e?.address,
        e?.transactionId,
        e?.selectedPhotos,
        e?.productName,
        e?.amountPayed,
        e?.transactionCompleted,
        e?.orderStatus,
        e?.eta
      ]);

  @override
  bool isValidKey(Object? o) => o is OrdersRecord;
}
