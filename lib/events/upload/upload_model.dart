import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'upload_widget.dart' show UploadWidget;
import 'package:flutter/material.dart';

class UploadModel extends FlutterFlowModel<UploadWidget> {
  ///  Local state fields for this page.

  bool isUploadDone = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  bool isDataUploading = false;
  List<FFUploadedFile> uploadedLocalFiles = [];
  List<String> uploadedFileUrls = [];

  // Stores action output result for [Custom Action - addurl] action in Upload widget.
  String? albumId;
  // Stores action output result for [Backend Call - API (SearchOnUpload)] action in Upload widget.
  ApiCallResponse? apiResultfv5;

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
