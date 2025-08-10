import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/ticker.dart';
import '../../../../domain/entities/pomodoro_settings.dart';
import '../../../../domain/usecases/load_settings.dart';
import '../../../../domain/usecases/save_settings.dart';
import 'controller_contract.dart';
import 'pomodoro_state.dart';

class PomodoroNotifier extends StateNotifier<PomodoroState> implements IPomodoroController {
  final Ticker _ticker;
  final LoadSettings _loadSettings;
  final SaveSettings _saveSettings;

  StreamSubscription<int>? _sub;

  PomodoroNotifier(this._ticker, this._loadSettings, this._saveSettings)
      : super(PomodoroState.initial());

  @override int get remainingSeconds => state.remainingSeconds;
  @override int get workMinutes => state.workMinutes;
  @override int get breakMinutes => state.breakMinutes;
  @override bool get isRunning => state.isRunning;
  @override PomodoroPhase get phase => state.phase;
  @override int get sessionsDone => state.sessionsDone;
  @override double get progress => state.progress;

  @override
  Future<void> init() async {
    final s = await _loadSettings();
    final p = PomodoroPhase.focus;
    final secs = (p == PomodoroPhase.focus ? s.workMinutes : s.breakMinutes) * 60;
    state = state.copyWith(
      workMinutes: s.workMinutes,
      breakMinutes: s.breakMinutes,
      phase: p,
      remainingSeconds: secs,
    );
  }

  void _resetPhaseTimer() {
    final secs = (state.phase == PomodoroPhase.focus ? state.workMinutes : state.breakMinutes) * 60;
    state = state.copyWith(remainingSeconds: secs);
  }

  void _tick() {
    if (state.remainingSeconds > 0) {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
    } else {
      final next = state.phase == PomodoroPhase.focus ? PomodoroPhase.breakTime : PomodoroPhase.focus;
      final add = state.phase == PomodoroPhase.focus ? 1 : 0;
      state = state.copyWith(phase: next, sessionsDone: state.sessionsDone + add);
      _resetPhaseTimer();
    }
  }

  @override
  Future<void> start() async {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true);
    _sub = _ticker.tick().listen((_) => _tick());
  }

  @override
  Future<void> pause() async {
    if (!state.isRunning) return;
    state = state.copyWith(isRunning: false);
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
    await _saveSettings(PomodoroSettings(workMinutes: workMin, breakMinutes: breakMin));
    state = state.copyWith(workMinutes: workMin, breakMinutes: breakMin);
    _resetPhaseTimer();
  }

  @override
  Future<void> dispose() async {
    await _sub?.cancel();
    super.dispose();
  }
}
