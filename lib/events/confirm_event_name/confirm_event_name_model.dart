import '/flutter_flow/flutter_flow_util.dart';
import 'confirm_event_name_widget.dart' show ConfirmEventNameWidget;
import 'package:flutter/material.dart';

class ConfirmEventNameModel extends FlutterFlowModel<ConfirmEventNameWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode;
  TextEditingController? yourNameController;
  String? Function(BuildContext, String?)? yourNameControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    yourNameFocusNode?.dispose();
    yourNameController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
