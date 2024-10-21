// Automatic FlutterFlow imports
import 'dart:io';

import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';

Future<bool> checkVersion() async {
  // Add your function code here!
  try {
    var query = await FirebaseFirestore.instance.collection('Constants').get();
    var version = query.docs[0].get('website_build_number');
    var info = await PackageInfo.fromPlatform();
    if (info.buildNumber.isEmpty) {
      return true;
    }
    if (Platform.isIOS) {
      return true;
    }
    if (info.buildNumber.toString() == version.toString()) {
      print(info.buildNumber.toString() + '==' + version.toString());
      print('check version returned true');
      return true;
    } else {
      print(info.buildNumber.toString() + '==' + version.toString());
      print('check version returned false');
      if (kDebugMode) {
        return true;
      } else {
        return false;
      }
    }
  } catch (ex) {
    print('Error in checkversion ' + ex.toString());
    return true;
  }
}
