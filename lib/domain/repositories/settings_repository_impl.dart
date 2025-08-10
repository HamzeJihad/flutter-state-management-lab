import 'package:flutter/material.dart';
import 'package:flutter_state_management_lab/data/datasources/local/prefs_datasource.dart';
import 'package:flutter_state_management_lab/data/models/pomodoro_settings_model.dart';
import '../../../domain/entities/pomodoro_settings.dart';
import '../../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final PrefsDataSource ds;
  SettingsRepositoryImpl(this.ds);

  @override
  Future<PomodoroSettings> load() async =>
      PomodoroSettingsModel.fromPrefs(ds).toEntity();

  @override
  Future<void> save(PomodoroSettings s) async =>
      PomodoroSettingsModel.fromEntity(s).toPrefs(ds);

  @override
  Future<Brightness> loadBrightness() async =>
      ds.getBrightness() == 'dark' ? Brightness.dark : Brightness.light;

  @override
  Future<void> saveBrightness(Brightness b) async =>
      ds.setBrightness(b == Brightness.dark ? 'dark' : 'light');
}
