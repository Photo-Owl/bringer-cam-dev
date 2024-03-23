import '/components/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'newhomeui_widget.dart' show NewhomeuiWidget;
import 'package:flutter/material.dart';

class NewhomeuiModel extends FlutterFlowModel<NewhomeuiWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - checkVersion] action in newhomeui widget.
  bool? versionCheckResult;
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
