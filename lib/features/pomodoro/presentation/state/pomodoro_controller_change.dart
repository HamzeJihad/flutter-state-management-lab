import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/ticker.dart';
import '../../../../domain/entities/pomodoro_settings.dart';
import '../../../../domain/usecases/load_settings.dart';
import '../../../../domain/usecases/save_settings.dart';
import 'controller_contract.dart';

class PomodoroControllerChange extends ChangeNotifier implements IPomodoroController {
  final Ticker _ticker;
  final LoadSettings _loadSettings;
  final SaveSettings _saveSettings;

  PomodoroControllerChange(this._ticker, this._loadSettings, this._saveSettings);

  int _remaining = 0;
  int _work = 25;
  int _break = 5;
  bool _running = false;
  PomodoroPhase _phase = PomodoroPhase.focus;
  int _sessions = 0;
  StreamSubscription<int>? _sub;

  @override int get remainingSeconds => _remaining;
  @override int get workMinutes => _work;
  @override int get breakMinutes => _break;
  @override bool get isRunning => _running;
  @override PomodoroPhase get phase => _phase;
  @override int get sessionsDone => _sessions;

  @override
  double get progress {
    final total = (_phase == PomodoroPhase.focus ? _work : _break) * 60;
    if (total == 0) return 0;
    return 1 - (_remaining / total);
  }

  @override
  Future<void> init() async {
    final s = await _loadSettings();
    _work = s.workMinutes;
    _break = s.breakMinutes;
    _resetPhaseTimer();
    notifyListeners();
  }

  void _resetPhaseTimer() {
    _remaining = (_phase == PomodoroPhase.focus ? _work : _break) * 60;
  }

  void _tick() {
    if (_remaining > 0) {
      _remaining -= 1;
      notifyListeners();
    } else {
      _onPhaseComplete();
    }
  }

  void _onPhaseComplete() {
    if (_phase == PomodoroPhase.focus) _sessions += 1;
    _phase = _phase == PomodoroPhase.focus ? PomodoroPhase.breakTime : PomodoroPhase.focus;
    _resetPhaseTimer();
    notifyListeners();
  }

  @override
  Future<void> start() async {
    if (_running) return;
    _running = true;
    _sub = _ticker.tick().listen((_) => _tick());
    notifyListeners();
  }

  @override
  Future<void> pause() async {
    _running = false;
    await _sub?.cancel();
    _sub = null;
    notifyListeners();
  }

  @override
  Future<void> reset() async {
    await pause();
    _resetPhaseTimer();
    notifyListeners();
  }

  @override
  Future<void> updateSettings({required int workMin, required int breakMin}) async {
    _work = workMin;
    _break = breakMin;
    await _saveSettings(PomodoroSettings(workMinutes: _work, breakMinutes: _break));
    _resetPhaseTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
