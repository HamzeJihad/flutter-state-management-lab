import 'package:shared_preferences/shared_preferences.dart';

class PrefsDataSource {
  static const _kWork = 'work_minutes';
  static const _kBreak = 'break_minutes';
  static const _kBrightness = 'brightness';

  final SharedPreferences prefs;
  PrefsDataSource(this.prefs);

  int getWork() => prefs.getInt(_kWork) ?? 25;
  int getBreak() => prefs.getInt(_kBreak) ?? 5;

  Future<void> setWork(int v) => prefs.setInt(_kWork, v);
  Future<void> setBreak(int v) => prefs.setInt(_kBreak, v);

  String getBrightness() => prefs.getString(_kBrightness) ?? 'light';
  Future<void> setBrightness(String s) => prefs.setString(_kBrightness, s);
}
