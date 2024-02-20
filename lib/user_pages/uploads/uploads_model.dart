import '/components/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'uploads_widget.dart' show UploadsWidget;
import 'package:flutter/material.dart';

class UploadsModel extends FlutterFlowModel<UploadsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - checkVersion] action in Uploads widget.
  bool? versionCheckResult;
  // Stores action output result for [Custom Action - readAllImagesSqlite] action in Uploads widget.
  List<dynamic>? uploadedImages;
  // Model for sidebar component.
  late SidebarModel sidebarModel;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    sidebarModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
