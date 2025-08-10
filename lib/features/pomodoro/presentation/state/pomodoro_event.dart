import 'package:equatable/equatable.dart';

class PomodoroEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PomodoroInitialized extends PomodoroEvent {}

class PomodoroStarted extends PomodoroEvent {}

class PomodoroPaused extends PomodoroEvent {}

class PomodoroReset extends PomodoroEvent {}

class PomodoroTicked extends PomodoroEvent {}

class PomodoroSettingsUpdated extends PomodoroEvent {
  final int workMin;
  final int breakMin;
  PomodoroSettingsUpdated({required this.workMin, required this.breakMin});

  @override
  List<Object?> get props => [workMin, breakMin];
}
