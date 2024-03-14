import '/flutter_flow/flutter_flow_util.dart';
import 'local_image_widget.dart' show LocalImageWidget;
import 'package:flutter/material.dart';

class LocalImageModel extends FlutterFlowModel<LocalImageWidget> {
  ///  Local state fields for this page.

  bool liked = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

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
