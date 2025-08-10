import 'dart:async';
import 'package:get/get.dart';
import '../../../../core/utils/ticker.dart';
import '../../../../domain/entities/pomodoro_settings.dart';
import '../../../../domain/usecases/load_settings.dart';
import '../../../../domain/usecases/save_settings.dart';
import 'controller_contract.dart';

class PomodoroGetxController extends GetxController implements IPomodoroController {
  final Ticker _ticker;
  final LoadSettings _loadSettings;
  final SaveSettings _saveSettings;

  PomodoroGetxController(this._ticker, this._loadSettings, this._saveSettings);

  final RxInt _remaining = 0.obs;
  final RxInt _work = 25.obs;
  final RxInt _break = 5.obs;
  final RxBool _running = false.obs;
  final Rx<PomodoroPhase> _phase = PomodoroPhase.focus.obs;
  final RxInt _sessions = 0.obs;

  StreamSubscription<int>? _sub;

  @override int get remainingSeconds => _remaining.value;
  @override int get workMinutes => _work.value;
  @override int get breakMinutes => _break.value;
  @override bool get isRunning => _running.value;
  @override PomodoroPhase get phase => _phase.value;
  @override int get sessionsDone => _sessions.value;

  @override
  double get progress {
    final total = (_phase.value == PomodoroPhase.focus ? _work.value : _break.value) * 60;
    if (total == 0) return 0;
    return 1 - (_remaining.value / total);
  }

  @override
  Future<void> init() async {
    final s = await _loadSettings();
    _work.value = s.workMinutes;
    _break.value = s.breakMinutes;
    _resetPhaseTimer();
  }

  void _resetPhaseTimer() {
    _remaining.value = (_phase.value == PomodoroPhase.focus ? _work.value : _break.value) * 60;
  }

  void _tick() {
    if (_remaining.value > 0) {
      _remaining.value -= 1;
    } else {
      if (_phase.value == PomodoroPhase.focus) _sessions.value += 1;
      _phase.value = _phase.value == PomodoroPhase.focus ? PomodoroPhase.breakTime : PomodoroPhase.focus;
      _resetPhaseTimer();
    }
  }

  @override
  Future<void> start() async {
    if (_running.value) return;
    _running.value = true;
    _sub = _ticker.tick().listen((_) => _tick());
  }

  @override
  Future<void> pause() async {
    if (!_running.value) return;
    _running.value = false;
    await _sub?.cancel();
    _sub = null;
  }

  @override
  Future<void> reset() async {
    await pause();
    _resetPhaseTimer();
  }

  @override
  Future<void> updateSettings({required int workMin, required int breakMin}) async {
    _work.value = workMin;
    _break.value = breakMin;
    await _saveSettings(PomodoroSettings(workMinutes: workMin, breakMinutes: breakMin));
    _resetPhaseTimer();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
