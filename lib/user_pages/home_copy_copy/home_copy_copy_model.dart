import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_copy_copy_widget.dart' show HomeCopyCopyWidget;
import 'package:flutter/material.dart';

class HomeCopyCopyModel extends FlutterFlowModel<HomeCopyCopyWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - checkVersion] action in HomeCopyCopy widget.
  bool? versionCheckResult;
  // Stores action output result for [Custom Action - getAllImages] action in HomeCopyCopy widget.
  List<TimelineItemStruct>? images;
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
