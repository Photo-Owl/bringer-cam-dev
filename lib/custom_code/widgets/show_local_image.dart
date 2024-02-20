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

import 'dart:io';

class ShowLocalImage extends StatefulWidget {
  const ShowLocalImage({
    super.key,
    this.width,
    this.height,
    this.path,
  });

  final double? width;
  final double? height;
  final String? path;

  @override
  State<ShowLocalImage> createState() => _ShowLocalImageState();
}

class _ShowLocalImageState extends State<ShowLocalImage> {
  @override
  Widget build(BuildContext context) {
    var imageFile = File(
        '/storage/emulated/0/Android/data/com.smoose.photoowldev/files/Pictures/CAP4934072218017907159.jpg');
    return Image.file(imageFile);
  }
}
