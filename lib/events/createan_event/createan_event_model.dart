import '/components/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'createan_event_widget.dart' show CreateanEventWidget;
import 'package:flutter/material.dart';

class CreateanEventModel extends FlutterFlowModel<CreateanEventWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - checkVersion] action in CreateanEvent widget.
  bool? versionCheckResult;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for sidebar component.
  late SidebarModel sidebarModel;

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
}
