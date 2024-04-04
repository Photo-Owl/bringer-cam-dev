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

import 'package:cached_network_image/cached_network_image.dart';

class FadeInImage extends StatefulWidget {
  const FadeInImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    required this.placeholderImage,
  });

  final double? width;
  final double? height;
  final String imageUrl;
  final String placeholderImage;

  @override
  State<FadeInImage> createState() => _FadeInImageState();
}

class _FadeInImageState extends State<FadeInImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            SizedBox(
              width: widget.width,
              height: widget.height,
              child: Image.network(
                widget.placeholderImage,
                fit: BoxFit.contain,
              ),
            ),
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
