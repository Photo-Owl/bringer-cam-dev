import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/more_ways_to_sign_in_widget.dart';
import '/components/update_required/update_required_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'social_sign_in_widget.dart' show SocialSignInWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SocialSignInModel extends FlutterFlowModel<SocialSignInWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - checkVersion] action in SocialSignIn widget.
  bool? checkVersionResult;
  // Stores action output result for [Firestore Query - Query a collection] action in Button widget.
  List<UsersRecord>? userDocumentaction;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
