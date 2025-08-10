import 'package:equatable/equatable.dart';
import 'controller_contract.dart';

class PomodoroState extends Equatable {
  final int remainingSeconds;
  final int workMinutes;
  final int breakMinutes;
  final bool isRunning;
  final PomodoroPhase phase;
  final int sessionsDone;

  const PomodoroState({
    required this.remainingSeconds,
    required this.workMinutes,
    required this.breakMinutes,
    required this.isRunning,
    required this.phase,
    required this.sessionsDone,
  });

  factory PomodoroState.initial() => const PomodoroState(
        remainingSeconds: 25 * 60,
        workMinutes: 25,
        breakMinutes: 5,
        isRunning: false,
        phase: PomodoroPhase.focus,
        sessionsDone: 0,
      );

  double get progress {
    final total = (phase == PomodoroPhase.focus ? workMinutes : breakMinutes) * 60;
    if (total == 0) return 0;
    return 1 - (remainingSeconds / total);
  }

  PomodoroState copyWith({
    int? remainingSeconds,
    int? workMinutes,
    int? breakMinutes,
    bool? isRunning,
    PomodoroPhase? phase,
    int? sessionsDone,
  }) {
    return PomodoroState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      workMinutes: workMinutes ?? this.workMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      isRunning: isRunning ?? this.isRunning,
      phase: phase ?? this.phase,
      sessionsDone: sessionsDone ?? this.sessionsDone,
    );
  }

  @override
  List<Object?> get props => [
        remainingSeconds,
        workMinutes,
        breakMinutes,
        isRunning,
        phase,
        sessionsDone,
      ];
}
