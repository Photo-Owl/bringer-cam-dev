import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  static final PrefManager _instance = PrefManager._internal();

  factory PrefManager() {
    return _instance;
  }

  late SharedPreferences _prefs;

  PrefManager._internal() {
    initPrefs();
  }

  Future<void> initPrefs() async {
    if (!_prefsInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _prefsInitialized = true;
    }
  }

  // Adjusted getter methods to ensure _prefs is initialized
  Future<SharedPreferences> get prefs async {
    if (!_prefsInitialized) {
      await initPrefs();
    }
    return _prefs;
  }

  bool _prefsInitialized = false;

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }
}
