import '/flutter_flow/flutter_flow_util.dart';
import '/payment_components/payment_processing/payment_processing_widget.dart';
import 'paymentpage_widget.dart' show PaymentpageWidget;
import 'package:flutter/material.dart';

class PaymentpageModel extends FlutterFlowModel<PaymentpageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - getidFromURI] action in Paymentpage widget.
  String? paymentRequestId;
  // Model for PaymentProcessing component.
  late PaymentProcessingModel paymentProcessingModel;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    paymentProcessingModel =
        createModel(context, () => PaymentProcessingModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    paymentProcessingModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
