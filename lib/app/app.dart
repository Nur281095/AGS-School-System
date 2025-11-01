import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class AgsSchoolSystemApp extends ConsumerWidget {
  const AgsSchoolSystemApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: 'AGS School System',
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
