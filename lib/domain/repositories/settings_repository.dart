import 'package:flutter/material.dart';
import '../entities/pomodoro_settings.dart';

abstract class SettingsRepository {
  Future<PomodoroSettings> load();
  Future<void> save(PomodoroSettings settings);

  Future<Brightness> loadBrightness();
  Future<void> saveBrightness(Brightness b);
}
