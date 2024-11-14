import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _preferences;

  static final SharedPref instance = SharedPref._init();

  SharedPref._init();

  Future<void> initPrefs() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  String? getStringValue(String key) {
    String? value = _preferences!.getString(key);
    return value;
  }

  int? getIntValue(String key) {
    int? value = _preferences!.getInt(key);
    return value;
  }

  Future setStringValue(String key, String value) async {
    await _preferences!.setString(key, value);
  }

  Future setIntValue(String key, int value) async {
    await _preferences!.setInt(key, value);
  }
}
