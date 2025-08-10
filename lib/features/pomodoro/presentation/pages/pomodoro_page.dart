import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/di/locator.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/time_formatter.dart';
import '../state/controller_contract.dart';
import '../state/pomodoro_getx_controller.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  late final PomodoroGetxController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PomodoroGetxController(sl(), sl(), sl()));
    controller.init();
  }

  @override
  void dispose() {
    controller.dispose();
    Get.delete<PomodoroGetxController>();
    super.dispose();
  }

  void _openSettings() async {
    final workCtrl = TextEditingController(text: controller.workMinutes.toString());
    final breakCtrl = TextEditingController(text: controller.breakMinutes.toString());
    final themeCtrl = sl<ThemeController>();

    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text('Ajustes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: workCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Minutos de foco', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: breakCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Minutos de pausa', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Tema escuro'),
                  const Spacer(),
                  ValueListenableBuilder(
                    valueListenable: themeCtrl.mode,
                    builder: (_, mode, _) => Switch(
                      value: mode == ThemeMode.dark,
                      onChanged: (_) async => await themeCtrl.toggle(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  final w = int.tryParse(workCtrl.text) ?? controller.workMinutes;
                  final b = int.tryParse(breakCtrl.text) ?? controller.breakMinutes;
                  await controller.updateSettings(workMin: w, breakMin: b);
                  if (Navigator.canPop(context)) Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final remaining = formatSeconds(controller.remainingSeconds);
      final isRunning = controller.isRunning;
      final isFocus = controller.phase == PomodoroPhase.focus;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Pomodinho'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _openSettings,
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isFocus ? 'Foco' : 'Pausa', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                SizedBox(
                  width: 180,
                  height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: controller.progress.clamp(0, 1),
                          strokeWidth: 10,
                        ),
                      ),
                      Text(
                        remaining,
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  children: [
                    FilledButton.tonal(
                      onPressed: isRunning ? null : controller.start,
                      child: const Text('Start'),
                    ),
                    FilledButton.tonal(
                      onPressed: isRunning ? controller.pause : null,
                      child: const Text('Pause'),
                    ),
                    FilledButton(
                      onPressed: controller.reset,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Sessões concluídas: ${controller.sessionsDone}'),
                const SizedBox(height: 8),
                Text(
                  'Foco: ${controller.workMinutes} min • Pausa: ${controller.breakMinutes} min',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
