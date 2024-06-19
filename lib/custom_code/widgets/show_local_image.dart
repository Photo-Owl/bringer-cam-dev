// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
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
import 'package:content_resolver/content_resolver.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class ShowLocalImage extends StatefulWidget {
  const ShowLocalImage({
    super.key,
    this.width,
    this.height,
    required this.path,
  });

  final double? width;
  final double? height;
  final String path;

  @override
  State<ShowLocalImage> createState() => _ShowLocalImageState();
}

class _ShowLocalImageState extends State<ShowLocalImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.path.startsWith('content://')) {
      final data = ContentResolver.resolveContent(widget.path);
      return FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Image.memory(snapshot.requireData.data, fit: BoxFit.cover);
          }
          return const Image(
            image: BlurHashImage('LAKBRFxu9FWB-;M{~qRj00xu00j['),
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.file(File(widget.path), fit: BoxFit.cover);
    }
  }
}
