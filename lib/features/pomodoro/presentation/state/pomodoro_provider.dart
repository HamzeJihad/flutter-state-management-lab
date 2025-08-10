import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/di/locator.dart';
import 'pomodoro_notifier.dart';
import 'pomodoro_state.dart';

final pomodoroProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroState>(
  (ref) => sl<PomodoroNotifier>()..init(),
);
