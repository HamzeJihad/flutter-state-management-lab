import '../entities/pomodoro_settings.dart';
import '../repositories/settings_repository.dart';

class LoadSettings {
  final SettingsRepository repo;
  LoadSettings(this.repo);
  Future<PomodoroSettings> call() => repo.load();
}
