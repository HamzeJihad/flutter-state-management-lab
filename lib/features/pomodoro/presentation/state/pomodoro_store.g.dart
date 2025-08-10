// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PomodoroStore on _PomodoroStore, Store {
  Computed<double>? _$progressComputed;

  @override
  double get progress => (_$progressComputed ??= Computed<double>(
    () => super.progress,
    name: '_PomodoroStore.progress',
  )).value;

  late final _$remainingSecondsAtom = Atom(
    name: '_PomodoroStore.remainingSeconds',
    context: context,
  );

  @override
  int get remainingSeconds {
    _$remainingSecondsAtom.reportRead();
    return super.remainingSeconds;
  }

  @override
  set remainingSeconds(int value) {
    _$remainingSecondsAtom.reportWrite(value, super.remainingSeconds, () {
      super.remainingSeconds = value;
    });
  }

  late final _$workMinutesAtom = Atom(
    name: '_PomodoroStore.workMinutes',
    context: context,
  );

  @override
  int get workMinutes {
    _$workMinutesAtom.reportRead();
    return super.workMinutes;
  }

  @override
  set workMinutes(int value) {
    _$workMinutesAtom.reportWrite(value, super.workMinutes, () {
      super.workMinutes = value;
    });
  }

  late final _$breakMinutesAtom = Atom(
    name: '_PomodoroStore.breakMinutes',
    context: context,
  );

  @override
  int get breakMinutes {
    _$breakMinutesAtom.reportRead();
    return super.breakMinutes;
  }

  @override
  set breakMinutes(int value) {
    _$breakMinutesAtom.reportWrite(value, super.breakMinutes, () {
      super.breakMinutes = value;
    });
  }

  late final _$isRunningAtom = Atom(
    name: '_PomodoroStore.isRunning',
    context: context,
  );

  @override
  bool get isRunning {
    _$isRunningAtom.reportRead();
    return super.isRunning;
  }

  @override
  set isRunning(bool value) {
    _$isRunningAtom.reportWrite(value, super.isRunning, () {
      super.isRunning = value;
    });
  }

  late final _$phaseAtom = Atom(name: '_PomodoroStore.phase', context: context);

  @override
  PomodoroPhase get phase {
    _$phaseAtom.reportRead();
    return super.phase;
  }

  @override
  set phase(PomodoroPhase value) {
    _$phaseAtom.reportWrite(value, super.phase, () {
      super.phase = value;
    });
  }

  late final _$sessionsDoneAtom = Atom(
    name: '_PomodoroStore.sessionsDone',
    context: context,
  );

  @override
  int get sessionsDone {
    _$sessionsDoneAtom.reportRead();
    return super.sessionsDone;
  }

  @override
  set sessionsDone(int value) {
    _$sessionsDoneAtom.reportWrite(value, super.sessionsDone, () {
      super.sessionsDone = value;
    });
  }

  late final _$initAsyncAction = AsyncAction(
    '_PomodoroStore.init',
    context: context,
  );

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$startAsyncAction = AsyncAction(
    '_PomodoroStore.start',
    context: context,
  );

  @override
  Future<void> start() {
    return _$startAsyncAction.run(() => super.start());
  }

  late final _$pauseAsyncAction = AsyncAction(
    '_PomodoroStore.pause',
    context: context,
  );

  @override
  Future<void> pause() {
    return _$pauseAsyncAction.run(() => super.pause());
  }

  late final _$resetAsyncAction = AsyncAction(
    '_PomodoroStore.reset',
    context: context,
  );

  @override
  Future<void> reset() {
    return _$resetAsyncAction.run(() => super.reset());
  }

  late final _$updateSettingsAsyncAction = AsyncAction(
    '_PomodoroStore.updateSettings',
    context: context,
  );

  @override
  Future<void> updateSettings({required int workMin, required int breakMin}) {
    return _$updateSettingsAsyncAction.run(
      () => super.updateSettings(workMin: workMin, breakMin: breakMin),
    );
  }

  late final _$disposeAsyncAction = AsyncAction(
    '_PomodoroStore.dispose',
    context: context,
  );

  @override
  Future<void> dispose() {
    return _$disposeAsyncAction.run(() => super.dispose());
  }

  @override
  String toString() {
    return '''
remainingSeconds: ${remainingSeconds},
workMinutes: ${workMinutes},
breakMinutes: ${breakMinutes},
isRunning: ${isRunning},
phase: ${phase},
sessionsDone: ${sessionsDone},
progress: ${progress}
    ''';
  }
}
