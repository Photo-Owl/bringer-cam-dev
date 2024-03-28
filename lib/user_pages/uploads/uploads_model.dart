import '/components/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'uploads_widget.dart' show UploadsWidget;
import 'package:flutter/material.dart';

class UploadsModel extends FlutterFlowModel<UploadsWidget> {
  ///  Local state fields for this page.

  int? uploadCount = 0;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - checkVersion] action in Uploads widget.
  bool? versionCheckResult;
  // Model for sidebar component.
  late SidebarModel sidebarModel;

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    sidebarModel.dispose();
  }
}
