import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'backend/api_requests/api_manager.dart';
import '/backend/sqlite/sqlite_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  int _websitebuildnumber = 1;
  int get websitebuildnumber => _websitebuildnumber;
  set websitebuildnumber(int _value) {
    _websitebuildnumber = _value;
  }

  bool _isUploading = false;
  bool get isUploading => _isUploading;
  set isUploading(bool _value) {
    _isUploading = _value;
  }

  double _uploadProgress = 0.0;
  double get uploadProgress => _uploadProgress;
  set uploadProgress(double _value) {
    _uploadProgress = _value;
  }
}
