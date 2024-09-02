import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dos_and_donts_copy_widget.dart' show DosAndDontsCopyWidget;
import 'package:flutter/material.dart';

class DosAndDontsCopyModel extends FlutterFlowModel<DosAndDontsCopyWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl = '';

  // Stores action output result for [Backend Call - API (userOnboarding)] action in Button widget.
  ApiCallResponse? apires;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
