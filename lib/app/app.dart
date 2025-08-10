import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'theme/app_theme.dart';
import 'di/locator.dart';
import '../features/pomodoro/presentation/state/pomodoro_controller_change.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = sl<ThemeController>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeCtrl.mode,
      builder: (_, mode, _) {
        return ChangeNotifierProvider<PomodoroControllerChange>(
          create: (_) {
            final c = PomodoroControllerChange(sl(), sl(), sl());
            c.init();
            return c;
          },
          child: MaterialApp(
            title: 'Pomodinho',
            themeMode: mode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const PomodoroPage(),
          ),
        );
      },
    );
  }
}
