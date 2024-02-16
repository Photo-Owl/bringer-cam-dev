import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/payment_components/payment_failed/payment_failed_widget.dart';
import '/payment_components/payment_pending/payment_pending_widget.dart';
import '/payment_components/payment_successful/payment_successful_widget.dart';
import 'payment_confirmation_widget.dart' show PaymentConfirmationWidget;
import 'package:flutter/material.dart';

class PaymentConfirmationModel
    extends FlutterFlowModel<PaymentConfirmationWidget> {
  ///  Local state fields for this page.

  bool? paymentStatus;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - getPidFromURI] action in PaymentConfirmation widget.
  String? paymentId;
  // Stores action output result for [Backend Call - API (Get Access Token)] action in PaymentConfirmation widget.
  ApiCallResponse? apiResult9yg;
  // Stores action output result for [Backend Call - API (Verify payment)] action in PaymentConfirmation widget.
  ApiCallResponse? apiResultqp3;
  // Model for PaymentPending component.
  late PaymentPendingModel paymentPendingModel;
  // Model for PaymentSuccessful component.
  late PaymentSuccessfulModel paymentSuccessfulModel;
  // Model for PaymentFailed component.
  late PaymentFailedModel paymentFailedModel;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    paymentPendingModel = createModel(context, () => PaymentPendingModel());
    paymentSuccessfulModel =
        createModel(context, () => PaymentSuccessfulModel());
    paymentFailedModel = createModel(context, () => PaymentFailedModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    paymentPendingModel.dispose();
    paymentSuccessfulModel.dispose();
    paymentFailedModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
