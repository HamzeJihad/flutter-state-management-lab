class PomodoroSettings {
  final int workMinutes;
  final int breakMinutes;

  const PomodoroSettings({required this.workMinutes, required this.breakMinutes});

  PomodoroSettings copyWith({int? workMinutes, int? breakMinutes}) =>
      PomodoroSettings(
        workMinutes: workMinutes ?? this.workMinutes,
        breakMinutes: breakMinutes ?? this.breakMinutes,
      );
}
