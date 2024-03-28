import '/components/home_page_tab_bar/home_page_tab_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'uploads_page_widget.dart' show UploadsPageWidget;
import 'package:flutter/material.dart';

class UploadsPageModel extends FlutterFlowModel<UploadsPageWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for HomePageTabBar component.
  late HomePageTabBarModel homePageTabBarModel;

  @override
  void initState(BuildContext context) {
    homePageTabBarModel = createModel(context, () => HomePageTabBarModel());
  }

  @override
  void dispose() {
    homePageTabBarModel.dispose();
  }
}
