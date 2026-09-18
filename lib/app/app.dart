import 'package:basecode/config/env.dart';
import 'package:basecode/core/theme/app_theme.dart';
import 'package:basecode/routing/app_router.dart';
import 'package:flutter/material.dart';

/// MaterialApp: theme, router, l10n.
class App extends StatelessWidget {
  const App({super.key, required this.env});

  final Env env;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: env.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      debugShowCheckedModeBanner: env.isDev,
      // home: const GalleryScreen(),
      // themeMode: ThemeMode.light,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
