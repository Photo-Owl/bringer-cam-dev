import '/flutter_flow/flutter_flow_util.dart';
import 'enter_event_name_widget.dart' show EnterEventNameWidget;
import 'package:flutter/material.dart';

class EnterEventNameModel extends FlutterFlowModel<EnterEventNameWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode;
  TextEditingController? yourNameTextController;
  String? Function(BuildContext, String?)? yourNameTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    yourNameFocusNode?.dispose();
    yourNameTextController?.dispose();
  }
}
