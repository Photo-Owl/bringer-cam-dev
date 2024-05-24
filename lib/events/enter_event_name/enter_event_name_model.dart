import '/flutter_flow/flutter_flow_util.dart';
import 'enter_event_name_widget.dart' show EnterEventNameWidget;
import 'package:flutter/material.dart';

class EnterEventNameModel extends FlutterFlowModel<EnterEventNameWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode;
  TextEditingController? yourNameController;
  String? Function(BuildContext, String?)? yourNameControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    yourNameFocusNode?.dispose();
    yourNameController?.dispose();
  }
}
