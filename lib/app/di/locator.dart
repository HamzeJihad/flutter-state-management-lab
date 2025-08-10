import 'package:flutter_state_management_lab/domain/repositories/settings_repository_impl.dart';
import 'package:flutter_state_management_lab/features/pomodoro/presentation/state/pomodoro_store.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/ticker.dart';
import '../../data/datasources/local/prefs_datasource.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/load_settings.dart';
import '../../domain/usecases/save_settings.dart';
import '../theme/app_theme.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();

  sl
  ..registerLazySingleton(() => ThemeController(sl()))
  ..registerLazySingleton(() => Ticker())
  ..registerLazySingleton(() => PrefsDataSource(prefs))
  ..registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl(sl()))
  ..registerLazySingleton(() => LoadSettings(sl()))
  ..registerLazySingleton(() => SaveSettings(sl()))
  ..registerFactory(() => PomodoroStore(sl(), sl(), sl()));
}
