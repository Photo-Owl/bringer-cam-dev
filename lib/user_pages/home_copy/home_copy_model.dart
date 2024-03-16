import '/backend/backend.dart';
import '/components/home_page_tab_bar/home_page_tab_bar_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import '/flutter_flow/request_manager.dart';

import 'home_copy_widget.dart' show HomeCopyWidget;
import 'package:flutter/material.dart';

class HomeCopyModel extends FlutterFlowModel<HomeCopyWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - checkVersion] action in HomeCopy widget.
  bool? versionCheckResult;
  // Model for sidebar component.
  late SidebarModel sidebarModel;
  // Model for HomePageTabBar component.
  late HomePageTabBarModel homePageTabBarModel;

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
