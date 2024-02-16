import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'imageexpanded_widget.dart' show ImageexpandedWidget;
import 'package:flutter/material.dart';

class ImageexpandedModel extends FlutterFlowModel<ImageexpandedWidget> {
  ///  Local state fields for this page.

  bool liked = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (DeleteImage)] action in IconButton widget.
  ApiCallResponse? apiResultpe6;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
