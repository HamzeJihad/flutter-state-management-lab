import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'theme/app_theme.dart';
import 'di/locator.dart';
import '../features/pomodoro/presentation/state/pomodoro_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCtrl = sl<ThemeController>();
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeCtrl.mode,
      builder: (_, mode, _) {
        return BlocProvider<PomodoroBloc>(
          create: (_) => sl<PomodoroBloc>()..init(),
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
