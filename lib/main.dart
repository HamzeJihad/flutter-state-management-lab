import 'package:flutter/material.dart';
import 'package:flutter_state_management_lab/app/theme/app_theme.dart';
import 'app/app.dart';
import 'app/di/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await sl<ThemeController>().init();
  runApp(const App());
}
