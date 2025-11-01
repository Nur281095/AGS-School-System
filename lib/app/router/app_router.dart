import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/teachers/presentation/pages/teachers_page.dart';
import '../theme/app_theme.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: TeachersPage.routePath,
    routes: [
      ShellRoute(
        builder: (context, state, child) => _AppShell(child: child),
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

class _AppShell extends ConsumerWidget {
  const _AppShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);

    return Scaffold(
      backgroundColor: theme.surfaceContainer,
      body: Row(
        children: [
          _NavigationRail(theme: theme),
          const VerticalDivider(width: 1),
          Expanded(
            child: Container(
              color: theme.scaffoldBackground,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationRail extends StatelessWidget {
  const _NavigationRail({required this.theme});

  final AppThemeData theme;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      backgroundColor: theme.navBackground,
      selectedIconTheme: IconThemeData(color: theme.primaryColor),
      selectedLabelTextStyle: TextStyle(
        color: theme.primaryColor,
        fontWeight: FontWeight.w600,
      ),
      minWidth: 200,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: Text('Teachers'),
        ),
      ],
      selectedIndex: 0,
    );
  }
}
