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

  @override
  void initState() {
    super.initState();
    final filters = ref.read(teacherFiltersProvider);
    _searchController = TextEditingController(text: filters.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(teacherFiltersProvider);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search by name or phone',
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: filters.hasQuery
                  ? IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(teacherFiltersProvider.notifier).state =
                            filters.copyWith(query: '');
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              ref.read(teacherFiltersProvider.notifier).state =
                  filters.copyWith(query: value);
            },
          ),
        ),
        const SizedBox(width: 16),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TeacherStatus?>(
                value: filters.status,
                items: [
                  const DropdownMenuItem<TeacherStatus?>(
                    value: null,
                    child: Text('All statuses'),
                  ),
                  ...TeacherStatus.values.map(
                    (status) => DropdownMenuItem<TeacherStatus>(
                      value: status,
                      child: Text(status.label),
                    ),
                  ),
                ],
                onChanged: (status) {
                  ref.read(teacherFiltersProvider.notifier).state =
                      filters.copyWith(status: status);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
