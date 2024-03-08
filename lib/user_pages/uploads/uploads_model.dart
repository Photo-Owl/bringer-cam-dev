import '/components/home_page_tab_bar/home_page_tab_bar_widget.dart';
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
  // Model for HomePageTabBar component.
  late HomePageTabBarModel homePageTabBarModel;
  // Model for sidebar component.
  late SidebarModel sidebarModel;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    homePageTabBarModel = createModel(context, () => HomePageTabBarModel());
    sidebarModel = createModel(context, () => SidebarModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    homePageTabBarModel.dispose();
    sidebarModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
