import '/flutter_flow/flutter_flow_util.dart';
import 'compare_images_widget.dart' show CompareImagesWidget;
import 'package:flutter/material.dart';

class CompareImagesModel extends FlutterFlowModel<CompareImagesWidget> {
  ///  Local state fields for this page.

  bool showOrginal = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
