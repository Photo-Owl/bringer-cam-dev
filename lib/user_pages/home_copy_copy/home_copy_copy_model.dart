import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/components/fetching_photos_widget.dart';
import '/components/sidebar/sidebar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_copy_copy_widget.dart' show HomeCopyCopyWidget;
import 'package:flutter/material.dart';

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
