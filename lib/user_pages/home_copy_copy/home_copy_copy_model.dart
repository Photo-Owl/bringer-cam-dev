import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/fetching_photos_widget.dart';
import '/components/give_name/give_name_widget.dart';
import '/components/no_photos/no_photos_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/components/update_required/update_required_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'home_copy_copy_widget.dart' show HomeCopyCopyWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

class HomeCopyCopyModel extends FlutterFlowModel<HomeCopyCopyWidget> {
  ///  Local state fields for this page.

  bool loaded = false;

  List<TimelineItemStruct> timeline = [];
  void addToTimeline(TimelineItemStruct item) => timeline.add(item);
  void removeFromTimeline(TimelineItemStruct item) => timeline.remove(item);
  void removeAtIndexFromTimeline(int index) => timeline.removeAt(index);
  void insertAtIndexInTimeline(int index, TimelineItemStruct item) =>
      timeline.insert(index, item);
  void updateTimelineAtIndex(
          int index, Function(TimelineItemStruct) updateFn) =>
      timeline[index] = updateFn(timeline[index]);

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - checkVersion] action in HomeCopyCopy widget.
  bool? versionCheckResult;
  // Stores action output result for [Custom Action - getAllImages] action in HomeCopyCopy widget.
  List<TimelineItemStruct>? timeline1;
  // Model for sidebar component.
  late SidebarModel sidebarModel;
  // Stores action output result for [Custom Action - getAllImages] action in ListView widget.
  List<TimelineItemStruct>? timeline2;
  // Model for FetchingPhotos component.
  late FetchingPhotosModel fetchingPhotosModel;

  @override
  void initState(BuildContext context) {
    sidebarModel = createModel(context, () => SidebarModel());
    fetchingPhotosModel = createModel(context, () => FetchingPhotosModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    sidebarModel.dispose();
    fetchingPhotosModel.dispose();
  }
}
