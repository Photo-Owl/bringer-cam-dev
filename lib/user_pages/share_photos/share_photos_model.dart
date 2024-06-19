import '/flutter_flow/flutter_flow_util.dart';
import 'share_photos_widget.dart' show SharePhotosWidget;
import 'package:flutter/material.dart';

class SharePhotosModel extends FlutterFlowModel<SharePhotosWidget> {
  ///  State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
