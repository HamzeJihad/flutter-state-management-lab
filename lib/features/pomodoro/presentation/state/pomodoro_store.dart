import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../../../core/utils/ticker.dart';
import '../../../../domain/entities/pomodoro_settings.dart';
import '../../../../domain/usecases/load_settings.dart';
import '../../../../domain/usecases/save_settings.dart';
import 'controller_contract.dart';

part 'pomodoro_store.g.dart';

class PomodoroStore = _PomodoroStore with _$PomodoroStore;

abstract class _PomodoroStore with Store implements IPomodoroController {
  final Ticker _ticker;
  final LoadSettings _loadSettings;
  final SaveSettings _saveSettings;

  _PomodoroStore(this._ticker, this._loadSettings, this._saveSettings);

  StreamSubscription<int>? _sub;

  @override
  @observable
  int remainingSeconds = 25 * 60;

  @override
  @observable
  int workMinutes = 25;

  @override
  @observable
  int breakMinutes = 5;

  @override
  @observable
  bool isRunning = false;

  @override
  @observable
  PomodoroPhase phase = PomodoroPhase.focus;

  @override
  @observable
  int sessionsDone = 0;

  @override
  @computed
  double get progress {
    final total = (phase == PomodoroPhase.focus ? workMinutes : breakMinutes) * 60;
    if (total == 0) return 0;
    return 1 - (remainingSeconds / total);
  }

  @override
  @action
  Future<void> init() async {
    final s = await _loadSettings();
    workMinutes = s.workMinutes;
    breakMinutes = s.breakMinutes;
    _resetPhaseTimer();
  }

  void _resetPhaseTimer() {
    remainingSeconds = (phase == PomodoroPhase.focus ? workMinutes : breakMinutes) * 60;
  }

  void _tick() {
    if (remainingSeconds > 0) {
      remainingSeconds -= 1;
    } else {
      if (phase == PomodoroPhase.focus) sessionsDone += 1;
      phase = phase == PomodoroPhase.focus ? PomodoroPhase.breakTime : PomodoroPhase.focus;
      _resetPhaseTimer();
    }
  }

  @override
  @action
  Future<void> start() async {
    if (isRunning) return;
    isRunning = true;
    _sub = _ticker.tick().listen((_) => _tick());
  }

  @override
  @action
  Future<void> pause() async {
    if (!isRunning) return;
    isRunning = false;
    await _sub?.cancel();
    _sub = null;
  }

  @override
  @action
  Future<void> reset() async {
    await pause();
    _resetPhaseTimer();
  }

  @override
  @action
  Future<void> updateSettings({required int workMin, required int breakMin}) async {
    await _saveSettings(PomodoroSettings(workMinutes: workMin, breakMinutes: breakMin));
    workMinutes = workMin;
    breakMinutes = breakMin;
    _resetPhaseTimer();
  }

  @override
  @action
  Future<void> dispose() async {
    await _sub?.cancel();
  }
}
