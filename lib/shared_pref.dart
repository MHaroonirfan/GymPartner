import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPreferences? _preferences;

  SharedPref instance = SharedPref._init();

  SharedPref._init();

  Future<SharedPreferences> getPrefs() async {
    if (_preferences != null) {
      return _preferences!;
    } else {
      _preferences = await SharedPreferences.getInstance();
      return _preferences!;
    }
  }

  dynamic getValue(String key, dynamic defaultValue) {
    dynamic value = _preferences!.get(key);
    return value;
  }

  Future setStringValue(String key, dynamic value) async {
    await _preferences!.setString(key, value);
  }
}
