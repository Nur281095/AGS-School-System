import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_providers.dart';
import '../../../application/teacher_metrics.dart';
import '../../../application/teacher_providers.dart';
import '../widgets/teacher_filters_bar.dart';
import '../widgets/teacher_table.dart';

class TeachersPage extends ConsumerWidget {
  const TeachersPage({super.key});

  static const routePath = '/teachers';
  static const routeName = 'teachers';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(databaseInitializerProvider);

    final metricsAsync = ref.watch(teacherMetricsProvider);
    final teachersAsync = ref.watch(teacherListProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeader(),
          const SizedBox(height: 24),
          _MetricsStrip(metricsAsync: metricsAsync),
          const SizedBox(height: 24),
          const TeacherFiltersBar(),
          const SizedBox(height: 24),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              child: teachersAsync.when(
                data: (teachers) {
                  if (teachers.isEmpty) {
                    return const _EmptyState();
                  }
                  return TeacherTable(teachers: teachers);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => _ErrorState(error: error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teachers',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage faculty profiles, availability, and contact information.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        FilledButton.icon(
          onPressed: () => TeacherTable.showCreateDialog(context),
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Add Teacher'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _MetricsStrip extends StatelessWidget {
  const _MetricsStrip({required this.metricsAsync});

  final AsyncValue<TeacherMetrics> metricsAsync;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return metricsAsync.when(
      data: (metrics) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _MetricCard(
              label: 'Total teachers',
              value: metrics.total,
              icon: Icons.people_alt_outlined,
              foregroundColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
            ),
            _MetricCard(
              label: 'Active',
              value: metrics.active,
              icon: Icons.verified_outlined,
              foregroundColor: const Color(0xFF22C55E),
              backgroundColor: const Color(0xFFDCFCE7),
            ),
            _MetricCard(
              label: 'Inactive',
              value: metrics.inactive,
              icon: Icons.pause_circle_outline,
              foregroundColor: const Color(0xFFF59E0B),
              backgroundColor: const Color(0xFFFDF4E7),
            ),
            _MetricCard(
              label: 'Archived',
              value: metrics.archived,
              icon: Icons.archive_outlined,
              foregroundColor: const Color(0xFFEF4444),
              backgroundColor: const Color(0xFFFEE2E2),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: foregroundColor, size: 28),
              ),
              const SizedBox(height: 18),
              Text(
                '$value',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                child: Icon(Icons.people_outline, size: 40, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 24),
              Text(
                'No teachers yet',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first teacher to start building the faculty roster and assigning classes.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => TeacherTable.showCreateDialog(context),
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Create teacher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
          const SizedBox(height: 12),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
