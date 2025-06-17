import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Singleton instance
  static final SharedPreferencesService _instance =
      SharedPreferencesService._internal();

  late final SharedPreferences _prefs;

  SharedPreferencesService._internal();

  static Future<void> init() async {
    _instance._prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferencesService get instance => _instance;

  // String
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) => _prefs.getString(key);

  // Bool
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) => _prefs.getBool(key);

  // Int
  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) => _prefs.getInt(key);

  // Double
  Future<void> saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  double? getDouble(String key) => _prefs.getDouble(key);

  // List<String>
  Future<void> saveStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // Remove & Clear
  Future<void> remove(String key) async => await _prefs.remove(key);

  Future<void> clear() async => await _prefs.clear();
}
