import '/flutter_flow/flutter_flow_util.dart';
import 'album_name_widget.dart' show AlbumNameWidget;
import 'package:flutter/material.dart';

class AlbumNameModel extends FlutterFlowModel<AlbumNameWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
