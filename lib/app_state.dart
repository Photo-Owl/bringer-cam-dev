import 'package:flutter/material.dart';

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
  set websitebuildnumber(int value) {
    _websitebuildnumber = value;
  }

  bool _isUploading = false;
  bool get isUploading => _isUploading;
  set isUploading(bool value) {
    _isUploading = value;
  }

  double _uploadProgress = 0.0;
  double get uploadProgress => _uploadProgress;
  set uploadProgress(double value) {
    _uploadProgress = value;
  }
}
