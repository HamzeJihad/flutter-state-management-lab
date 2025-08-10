import '../entities/pomodoro_settings.dart';
import '../repositories/settings_repository.dart';

class SaveSettings {
  final SettingsRepository repo;
  SaveSettings(this.repo);
  Future<void> call(PomodoroSettings s) => repo.save(s);
}
