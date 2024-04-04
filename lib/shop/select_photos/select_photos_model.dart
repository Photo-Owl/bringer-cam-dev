import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'select_photos_widget.dart' show SelectPhotosWidget;
import 'package:flutter/material.dart';

class SelectPhotosModel extends FlutterFlowModel<SelectPhotosWidget> {
  ///  Local state fields for this page.

  List<String> selectedPhotos = [];
  void addToSelectedPhotos(String item) => selectedPhotos.add(item);
  void removeFromSelectedPhotos(String item) => selectedPhotos.remove(item);
  void removeAtIndexFromSelectedPhotos(int index) =>
      selectedPhotos.removeAt(index);
  void insertAtIndexInSelectedPhotos(int index, String item) =>
      selectedPhotos.insert(index, item);
  void updateSelectedPhotosAtIndex(int index, Function(String) updateFn) =>
      selectedPhotos[index] = updateFn(selectedPhotos[index]);

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Backend Call - API (GetReviwOrderDetails)] action in Button widget.
  ApiCallResponse? apiResults;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
