import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/review_orderpop/review_orderpop_widget.dart';
import '/flutter_flow/flutter_flow_expanded_image_view.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'select_photos_widget.dart' show SelectPhotosWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

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

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
