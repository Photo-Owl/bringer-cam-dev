import '/flutter_flow/flutter_flow_util.dart';
import 'product_widget.dart' show ProductWidget;
import 'package:flutter/material.dart';

class ProductModel extends FlutterFlowModel<ProductWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
