import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/teachers/presentation/pages/teachers_page.dart';
import '../theme/app_theme.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  static final _destinations = <_Destination>[
    _Destination(
      icon: Icons.school_outlined,
      selectedIcon: Icons.school,
      label: 'Teachers',
      route: TeachersPage.routePath,
    ),
  ];

  int _selectedIndexForLocation(String location) {
    final index = _destinations.indexWhere((destination) {
      return location.startsWith(destination.route);
    });
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    final router = GoRouter.of(context);
    final selectedIndex = _selectedIndexForLocation(router.location);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.gradientStart, theme.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NavigationPanel(
                theme: theme,
                selectedIndex: selectedIndex,
                onSelected: (index) {
                  final destination = _destinations[index];
                  if (destination.route != router.location) {
                    router.go(destination.route);
                  }
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.surfaceLayer,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: theme.surfaceBorder),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A3652F4),
                          blurRadius: 32,
                          offset: Offset(0, 24),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Column(
                        children: [
                          const _AppHeader(),
                          const Divider(height: 1),
                          Expanded(
                            child: Container(
                              color: theme.surfaceLayer,
                              child: child,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationPanel extends StatelessWidget {
  const _NavigationPanel({
    required this.theme,
    required this.selectedIndex,
    required this.onSelected,
  });

  final AppTheme theme;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.navigationBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.surfaceBorder),
        ),
        child: NavigationRail(
          selectedIndex: selectedIndex,
          onDestinationSelected: onSelected,
          backgroundColor: Colors.transparent,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          labelType: NavigationRailLabelType.all,
          destinations: _destinations
              .map(
                (destination) => NavigationRailDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(destination.selectedIcon),
                  label: Text(destination.label),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _AppHeader extends ConsumerWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      alignment: Alignment.center,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AGS School System',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Faculty planning and operations dashboard',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_moon_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Offline ready',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Destination {
  const _Destination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
}
