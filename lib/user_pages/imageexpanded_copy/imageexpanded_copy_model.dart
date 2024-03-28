import '/flutter_flow/flutter_flow_util.dart';
import 'imageexpanded_copy_widget.dart' show ImageexpandedCopyWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageexpandedCopyModel extends FlutterFlowModel<ImageexpandedCopyWidget> {
  ///  Local state fields for this page.

  bool liked = false;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for Carousel widget.
  CarouselController? carouselController;

  int carouselCurrentIndex = 1;

  // Stores action output result for [Custom Action - getDownloadUrl] action in Container widget.
  String? downloadUrl1;
  // Stores action output result for [Custom Action - getDownloadUrl] action in Container widget.
  String? downloadUrl;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
