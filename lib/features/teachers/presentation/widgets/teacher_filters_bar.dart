import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/teacher.dart';
import '../../../application/teacher_filters.dart';
import '../../../application/teacher_providers.dart';

class TeacherFiltersBar extends ConsumerStatefulWidget {
  const TeacherFiltersBar({super.key});

  @override
  ConsumerState<TeacherFiltersBar> createState() => _TeacherFiltersBarState();
}

class _TeacherFiltersBarState extends ConsumerState<TeacherFiltersBar> {
  late final TextEditingController _searchController;
  ProviderSubscription<TeacherFilters>? _filtersSubscription;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(teacherFiltersProvider);
    _searchController = TextEditingController(text: filters.query);
    _filtersSubscription = ref.listen<TeacherFilters>(
      teacherFiltersProvider,
      (_, next) {
        if (_searchController.text != next.query) {
          _searchController.value = TextEditingValue(
            text: next.query,
            selection: TextSelection.collapsed(offset: next.query.length),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _filtersSubscription?.close();
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilters(TeacherFilters Function(TeacherFilters current) builder) {
    final notifier = ref.read(teacherFiltersProvider.notifier);
    notifier.state = builder(notifier.state);
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 220), () {
      _updateFilters((current) => current.copyWith(query: value));
    });
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(teacherFiltersProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search teachers by name, phone, or email',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: filters.hasQuery
                          ? IconButton(
                              tooltip: 'Clear search',
                              onPressed: () {
                                _searchController.clear();
                                _updateFilters((current) => current.copyWith(query: ''));
                              },
                              icon: const Icon(Icons.close_rounded),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _SortMenu(sort: filters.sort, onSelected: (sort) {
                  _updateFilters((current) => current.copyWith(sort: sort));
                }),
                const SizedBox(width: 8),
                if (filters.hasQuery || filters.hasStatus || filters.sort != TeacherSort.alphabetical)
                  TextButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      _updateFilters((_) => const TeacherFilters());
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reset'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StatusChip(
                  label: 'All statuses',
                  icon: Icons.all_inclusive,
                  selected: filters.status == null,
                  onSelected: () => _updateFilters((current) => current.copyWith(status: null)),
                  color: theme.colorScheme.primary,
                ),
                ...TeacherStatus.values.map(
                  (status) => _StatusChip(
                    label: status.label,
                    icon: _iconForStatus(status),
                    selected: filters.status == status,
                    onSelected: () => _updateFilters(
                      (current) => current.copyWith(
                        status: current.status == status ? null : status,
                      ),
                    ),
                    color: _colorForStatus(status, theme),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForStatus(TeacherStatus status) {
    switch (status) {
      case TeacherStatus.active:
        return Icons.verified_user_outlined;
      case TeacherStatus.inactive:
        return Icons.pause_circle_outline;
      case TeacherStatus.archived:
        return Icons.archive_outlined;
    }
  }

  Color _colorForStatus(TeacherStatus status, ThemeData theme) {
    switch (status) {
      case TeacherStatus.active:
        return const Color(0xFF22C55E);
      case TeacherStatus.inactive:
        return const Color(0xFFF59E0B);
      case TeacherStatus.archived:
        return theme.colorScheme.error;
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onSelected,
    required this.color,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onSelected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      selected: selected,
      onSelected: (_) => onSelected(),
      avatar: Icon(icon, size: 18, color: selected ? Colors.white : color),
      label: Text(label),
      selectedColor: color,
      showCheckmark: false,
      backgroundColor: color.withOpacity(0.12),
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: selected ? Colors.white : theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}

class _SortMenu extends StatelessWidget {
  const _SortMenu({required this.sort, required this.onSelected});

  final TeacherSort sort;
  final ValueChanged<TeacherSort> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TeacherSort>(
      tooltip: 'Sort teachers',
      initialValue: sort,
      onSelected: onSelected,
      itemBuilder: (context) {
        return TeacherSort.values
            .map(
              (value) => PopupMenuItem<TeacherSort>(
                value: value,
                child: Row(
                  children: [
                    Icon(value.icon, size: 18),
                    const SizedBox(width: 12),
                    Text(value.label),
                  ],
                ),
              ),
            )
            .toList();
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(sort.icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Text(sort.label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
