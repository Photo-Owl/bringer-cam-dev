import '/flutter_flow/flutter_flow_util.dart';
import 'skip_selfie_widget.dart' show SkipSelfieWidget;
import 'package:flutter/material.dart';

class SkipSelfieModel extends FlutterFlowModel<SkipSelfieWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
