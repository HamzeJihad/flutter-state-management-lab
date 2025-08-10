import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/ticker.dart';
import '../../../../domain/entities/pomodoro_settings.dart';
import '../../../../domain/usecases/load_settings.dart';
import '../../../../domain/usecases/save_settings.dart';
import 'controller_contract.dart';
import 'pomodoro_state.dart';

class PomodoroCubit extends Cubit<PomodoroState> implements IPomodoroController {
  final Ticker _ticker;
  final LoadSettings _loadSettings;
  final SaveSettings _saveSettings;

  StreamSubscription<int>? _sub;

  PomodoroCubit(this._ticker, this._loadSettings, this._saveSettings)
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
    final initialPhase = PomodoroPhase.focus;
    final secs = (initialPhase == PomodoroPhase.focus ? s.workMinutes : s.breakMinutes) * 60;
    emit(state.copyWith(
      workMinutes: s.workMinutes,
      breakMinutes: s.breakMinutes,
      phase: initialPhase,
      remainingSeconds: secs,
    ));
  }

  void _resetPhaseTimer() {
    final secs =
        (state.phase == PomodoroPhase.focus ? state.workMinutes : state.breakMinutes) * 60;
    emit(state.copyWith(remainingSeconds: secs));
  }

  void _tick() {
    if (state.remainingSeconds > 0) {
      emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
    } else {
      _onPhaseComplete();
    }
  }

  void _onPhaseComplete() {
    final nextPhase =
        state.phase == PomodoroPhase.focus ? PomodoroPhase.breakTime : PomodoroPhase.focus;
    final addSession = state.phase == PomodoroPhase.focus ? 1 : 0;
    emit(state.copyWith(
      phase: nextPhase,
      sessionsDone: state.sessionsDone + addSession,
    ));
    _resetPhaseTimer();
  }

  @override
  Future<void> start() async {
    if (state.isRunning) return;
    emit(state.copyWith(isRunning: true));
    _sub = _ticker.tick().listen((_) => _tick());
  }

  @override
  Future<void> pause() async {
    if (!state.isRunning) return;
    emit(state.copyWith(isRunning: false));
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
    emit(state.copyWith(workMinutes: workMin, breakMinutes: breakMin));
    _resetPhaseTimer();
  }

  @override
  Future<void> dispose() async {
    await close();
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
