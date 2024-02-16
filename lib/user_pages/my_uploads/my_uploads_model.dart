import '/components/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'my_uploads_widget.dart' show MyUploadsWidget;
import 'package:flutter/material.dart';

class MyUploadsModel extends FlutterFlowModel<MyUploadsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - checkVersion] action in MyUploads widget.
  bool? versionCheckResult;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

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
    tabBarController?.dispose();
    sidebarModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
