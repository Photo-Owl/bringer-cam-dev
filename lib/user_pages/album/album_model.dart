import '/flutter_flow/flutter_flow_util.dart';
import 'album_widget.dart' show AlbumWidget;
import 'package:flutter/material.dart';

class AlbumModel extends FlutterFlowModel<AlbumWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
