import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'sign_in_copy_widget.dart' show SignInCopyWidget;
import 'package:flutter/material.dart';

class SignInCopyModel extends FlutterFlowModel<SignInCopyWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Custom Action - checkVersion] action in SignInCopy widget.
  bool? checkVersionResult;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  String? _textController2Validator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 9) {
      return 'Number Not Valid';
    }

    return null;
  }

  // Stores action output result for [Firestore Query - Query a collection] action in Button-Login widget.
  List<UsersRecord>? userDocument;

  @override
  void initState(BuildContext context) {
    textController2Validator = _textController2Validator;
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
