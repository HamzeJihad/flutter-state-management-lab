import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/ticker.dart';
import '../../../../domain/entities/pomodoro_settings.dart';
import '../../../../domain/usecases/load_settings.dart';
import '../../../../domain/usecases/save_settings.dart';
import 'controller_contract.dart';
import 'pomodoro_event.dart';
import 'pomodoro_state.dart';

class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> implements IPomodoroController {
  final Ticker _ticker;
  final LoadSettings _loadSettings;
  final SaveSettings _saveSettings;

  StreamSubscription<int>? _sub;

  PomodoroBloc(this._ticker, this._loadSettings, this._saveSettings)
      : super(PomodoroState.initial()) {
    on<PomodoroInitialized>(_onInitialized);
    on<PomodoroStarted>(_onStarted);
    on<PomodoroPaused>(_onPaused);
    on<PomodoroReset>(_onReset);
    on<PomodoroTicked>(_onTicked);
    on<PomodoroSettingsUpdated>(_onSettingsUpdated);
  }

  @override int get remainingSeconds => state.remainingSeconds;
  @override int get workMinutes => state.workMinutes;
  @override int get breakMinutes => state.breakMinutes;
  @override bool get isRunning => state.isRunning;
  @override PomodoroPhase get phase => state.phase;
  @override int get sessionsDone => state.sessionsDone;
  @override double get progress => state.progress;

  @override
  Future<void> init() async {
    add(PomodoroInitialized());
  }

  Future<void> _onInitialized(PomodoroInitialized event, Emitter<PomodoroState> emit) async {
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

  void _resetPhaseTimer(Emitter<PomodoroState> emit) {
    final secs =
        (state.phase == PomodoroPhase.focus ? state.workMinutes : state.breakMinutes) * 60;
    emit(state.copyWith(remainingSeconds: secs));
  }

  void _onTicked(PomodoroTicked event, Emitter<PomodoroState> emit) {
    if (state.remainingSeconds > 0) {
      emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
    } else {
      final nextPhase =
          state.phase == PomodoroPhase.focus ? PomodoroPhase.breakTime : PomodoroPhase.focus;
      final addSession = state.phase == PomodoroPhase.focus ? 1 : 0;
      emit(state.copyWith(
        phase: nextPhase,
        sessionsDone: state.sessionsDone + addSession,
      ));
      _resetPhaseTimer(emit);
    }
  }

  Future<void> _onStarted(PomodoroStarted event, Emitter<PomodoroState> emit) async {
    if (state.isRunning) return;
    emit(state.copyWith(isRunning: true));
    _sub = _ticker.tick().listen((_) => add(PomodoroTicked()));
  }

  Future<void> _onPaused(PomodoroPaused event, Emitter<PomodoroState> emit) async {
    if (!state.isRunning) return;
    emit(state.copyWith(isRunning: false));
    await _sub?.cancel();
    _sub = null;
  }

  Future<void> _onReset(PomodoroReset event, Emitter<PomodoroState> emit) async {
    add(PomodoroPaused());
    await Future<void>.delayed(Duration.zero);
    _resetPhaseTimer(emit);
  }

  Future<void> _onSettingsUpdated(PomodoroSettingsUpdated event, Emitter<PomodoroState> emit) async {
    await _saveSettings(PomodoroSettings(workMinutes: event.workMin, breakMinutes: event.breakMin));
    emit(state.copyWith(workMinutes: event.workMin, breakMinutes: event.breakMin));
    _resetPhaseTimer(emit);
  }

  @override
  Future<void> start() async {
    add(PomodoroStarted());
  }

  @override
  Future<void> pause() async {
    add(PomodoroPaused());
  }

  @override
  Future<void> reset() async {
    add(PomodoroReset());
  }

  @override
  Future<void> updateSettings({required int workMin, required int breakMin}) async {
    add(PomodoroSettingsUpdated(workMin: workMin, breakMin: breakMin));
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
