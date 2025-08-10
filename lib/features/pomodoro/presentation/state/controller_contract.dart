enum PomodoroPhase { focus, breakTime }

abstract class IPomodoroController {
  int get remainingSeconds;
  int get workMinutes;
  int get breakMinutes;
  bool get isRunning;
  PomodoroPhase get phase;
  int get sessionsDone;
  double get progress;

  Future<void> init();
  Future<void> start();
  Future<void> pause();
  Future<void> reset();
  Future<void> updateSettings({required int workMin, required int breakMin});
  void dispose();
}
