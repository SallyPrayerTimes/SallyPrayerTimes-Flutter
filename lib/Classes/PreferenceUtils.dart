import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {

  static Future<SharedPreferences> get _instance async => _prefs ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefs;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefs = await _instance;
    return _prefs;
  }

  //sets
  static Future<bool> setBool(String key, bool value) async =>
      await _prefs!.setBool(key, value);

  static Future<bool> setDouble(String key, double value) async =>
      await _prefs!.setDouble(key, value);

  static Future<bool> setInt(String key, int value) async =>
      await _prefs!.setInt(key, value);

  static Future<bool> setString(String key, String value) async =>
      await _prefs!.setString(key, value);

  static Future<bool> setStringList(String key, List<String> value) async =>
      await _prefs!.setStringList(key, value);

  //gets
  static bool getBool(String key,[bool? defValue]) => _prefs!.getBool(key)??defValue??false;

  static double getDouble(String key,[double? defValue]) => _prefs!.getDouble(key)??defValue??0.0;

  static int getInt(String key,[int? defValue]) => _prefs!.getInt(key)??defValue??0;

  static String getString(String key,[String? defValue]) => _prefs!.getString(key)??defValue??"";

  static List<String>? getStringList(String key) => _prefs!.getStringList(key);

  //deletes..
  static Future<bool> remove(String key) async => await _prefs!.remove(key);

  static Future<bool> clear() async => await _prefs!.clear();

  static Future<void> reload() async => await _prefs!.reload();
}