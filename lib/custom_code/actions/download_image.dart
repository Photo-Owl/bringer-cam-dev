// Automatic FlutterFlow imports
import 'dart:io';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:android_download_manager/android_download_manager.dart';

Future<void> downloadImage(String url, String key) async {
  print('Downloading image from: $url');
  final [_, fileName] = key.split('/');
  if (kIsWeb) {
    await FileSaver.instance.saveFile(
      name: fileName,
      link: LinkDetails(link: url),
    );
    return;
  }
  print(' is ios ${Platform.isIOS}');
  if (Platform.isIOS) {
    // Request photos permission
    var status = await Permission.photos.request();
    // if (status.isGranted) {
    try {
      // Download the file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Save the image to gallery
        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.bodyBytes),
          name: fileName,
        );
        if (result['isSuccess']) {
          print('Image saved to gallery successfully');
        } else {
          print('Failed to save image to gallery');
        }
      } else {
        print('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while saving image: $e');
    }
    // } else {
    //   print('Photos permission denied');
    // }
    return;
  }
  if (Platform.isAndroid) {
    AndroidDownloadManager.enqueue(
      downloadUrl: url,
      downloadPath: '/sdcard/Pictures/Social Gallery/',
      fileName: fileName,
    );
  }
}
