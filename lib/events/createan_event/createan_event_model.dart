import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/give_name/give_name_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/update_required/update_required_widget.dart';
import '/events/enter_event_name/enter_event_name_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'createan_event_widget.dart' show CreateanEventWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
