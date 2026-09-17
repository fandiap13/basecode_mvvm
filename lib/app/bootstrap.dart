import 'package:basecode/app/app.dart';
import 'package:basecode/config/env.dart';
import 'package:basecode/config/flavor.dart';
import 'package:flutter/material.dart';

/// Inisialisasi sebelum `runApp`. Semua entrypoint flavor masuk lewat sini.
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();

  final env = Env.of(flavor);

  // debugPrint(flavor);
  debugPrint('Flavor: $flavor');
  debugPrint('API URL: ${env.appName}');
  debugPrint('API URL: ${env.baseUrl}');
  debugPrint('API URL: ${env.flavor}');

  runApp(App(env: env));
}
