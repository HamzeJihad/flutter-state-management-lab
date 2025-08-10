import 'package:flutter_state_management_lab/data/datasources/local/prefs_datasource.dart';

import '../../../domain/entities/pomodoro_settings.dart';

class PomodoroSettingsModel {
  final int work;
  final int rest;

  PomodoroSettingsModel({required this.work, required this.rest});

  PomodoroSettings toEntity() =>
      PomodoroSettings(workMinutes: work, breakMinutes: rest);

  static PomodoroSettingsModel fromPrefs(PrefsDataSource ds) =>
      PomodoroSettingsModel(work: ds.getWork(), rest: ds.getBreak());

  static PomodoroSettingsModel fromEntity(PomodoroSettings e) =>
      PomodoroSettingsModel(work: e.workMinutes, rest: e.breakMinutes);

  Future<void> toPrefs(PrefsDataSource ds) async {
    await ds.setWork(work);
    await ds.setBreak(rest);
  }
}
