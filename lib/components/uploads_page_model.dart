import '/auth/firebase_auth/auth_util.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/components/home_page_tab_bar/home_page_tab_bar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'uploads_page_widget.dart' show UploadsPageWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
