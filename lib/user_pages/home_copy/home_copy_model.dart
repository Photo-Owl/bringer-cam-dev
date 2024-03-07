import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/fetching_photos_widget.dart';
import '/components/give_name/give_name_widget.dart';
import '/components/home_page_tab_bar/home_page_tab_bar_widget.dart';
import '/components/no_photos/no_photos_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/update_required/update_required_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/request_manager.dart';

import 'home_copy_widget.dart' show HomeCopyWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

class HomeCopyModel extends FlutterFlowModel<HomeCopyWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - checkVersion] action in HomeCopy widget.
  bool? versionCheckResult;
  // Model for sidebar component.
  late SidebarModel sidebarModel;
  // Model for HomePageTabBar component.
  late HomePageTabBarModel homePageTabBarModel;
  // Stores action output result for [Backend Call - API (searchFacesUsingTIF)] action in ListView widget.
  ApiCallResponse? apiResultruf;

  /// Query cache managers for this widget.

  final _albumInfoManager = StreamRequestManager<List<AlbumsRecord>>();
  Stream<List<AlbumsRecord>> albumInfo({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<AlbumsRecord>> Function() requestFn,
  }) =>
      _albumInfoManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearAlbumInfoCache() => _albumInfoManager.clear();
  void clearAlbumInfoCacheKey(String? uniqueKey) =>
      _albumInfoManager.clearRequest(uniqueKey);

  final _albumPreviewManager = StreamRequestManager<List<UploadsRecord>>();
  Stream<List<UploadsRecord>> albumPreview({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Stream<List<UploadsRecord>> Function() requestFn,
  }) =>
      _albumPreviewManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearAlbumPreviewCache() => _albumPreviewManager.clear();
  void clearAlbumPreviewCacheKey(String? uniqueKey) =>
      _albumPreviewManager.clearRequest(uniqueKey);

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
    homePageTabBarModel = createModel(context, () => HomePageTabBarModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    sidebarModel.dispose();
    homePageTabBarModel.dispose();

    /// Dispose query cache managers for this widget.

    clearAlbumInfoCache();

    clearAlbumPreviewCache();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
