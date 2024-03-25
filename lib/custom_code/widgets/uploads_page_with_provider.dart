// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/custom_code/actions/uploader.dart';
import '/components/uploads_page_widget.dart';

class UploadsPageWithProvider extends StatefulWidget {
  const UploadsPageWithProvider({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<UploadsPageWithProvider> createState() =>
      _UploadsPageWithProviderState();
}

class _UploadsPageWithProviderState extends State<UploadsPageWithProvider> {
  @override
  Widget build(BuildContext context) {
    final appState = context.read<FFAppState>();
    final uploader = Uploader();
    uploader.appState = appState;
    return UploadsPageWidget(uploadProgress: appState.uploadProgress);
  }
}
