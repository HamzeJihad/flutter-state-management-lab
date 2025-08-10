import 'package:flutter/material.dart';
import '../../domain/repositories/settings_repository.dart';

class ThemeController {
  final SettingsRepository _repo;
  final ValueNotifier<ThemeMode> mode;

  ThemeController(this._repo) : mode = ValueNotifier(ThemeMode.light);

  Future<void> init() async {
    final b = await _repo.loadBrightness();
    mode.value = (b == Brightness.dark) ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> set(ThemeMode m) async {
    mode.value = m;
    await _repo.saveBrightness(
      m == ThemeMode.dark ? Brightness.dark : Brightness.light,
    );
  }

  Future<void> toggle() async {
    final next = mode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await set(next);
  }
}

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
  useMaterial3: true,
);
