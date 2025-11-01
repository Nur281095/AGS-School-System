import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/teachers/presentation/pages/teachers_page.dart';
import '../view/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: TeachersPage.routePath,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: TeachersPage.routePath,
            name: TeachersPage.routeName,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: TeachersPage(),
            ),
          ),
        ],
      ),
    ],
  );
});
