import 'package:basecode/config/flavor.dart';

/// Satu-satunya tempat yang membaca `String.fromEnvironment`.
///
/// Nilai diisi lewat `--dart-define-from-file=env/<flavor>.json`. Jangan
/// menaruh secret di sini: nilainya bisa diekstrak dari binary.
class Env {
  const Env({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
  });

  factory Env.of(Flavor flavor) => Env(
    flavor: flavor,
    appName: const String.fromEnvironment('APP_NAME', defaultValue: 'Basecode'),
    baseUrl: const String.fromEnvironment(
      'BASE_URL',
      defaultValue: "https://dev.example.com",
    ),
  );

  final Flavor flavor;
  final String appName;
  final String baseUrl;

  bool get isDev => flavor.isDev;
}
