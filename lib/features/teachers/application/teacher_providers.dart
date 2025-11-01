import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/app_providers.dart';
import '../../../core/models/teacher.dart';
import 'teacher_filters.dart';
import 'teacher_metrics.dart';

final teacherFiltersProvider = StateProvider<TeacherFilters>((ref) {
  return const TeacherFilters();
});

final teacherStreamProvider = StreamProvider.autoDispose<List<Teacher>>((ref) {
  final repository = ref.watch(teacherRepositoryProvider);
  return repository.watchTeachers();
});

final teacherListProvider = Provider.autoDispose<AsyncValue<List<Teacher>>>((ref) {
  final filters = ref.watch(teacherFiltersProvider);
  final teachersAsync = ref.watch(teacherStreamProvider);

  return teachersAsync.whenData((teachers) {
    Iterable<Teacher> filtered = teachers;

    if (filters.hasStatus) {
      filtered = filtered.where((teacher) => teacher.status == filters.status);
    }

    if (filters.hasQuery) {
      final query = filters.query.toLowerCase();
      filtered = filtered.where((teacher) {
        final tokens = [
          teacher.fullName,
          teacher.phone,
          teacher.email,
          teacher.cnic ?? '',
        ].join(' ').toLowerCase();
        return tokens.contains(query);
      });
    }

    final results = filtered.toList();
    switch (filters.sort) {
      case TeacherSort.alphabetical:
        results.sort((a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));
        break;
      case TeacherSort.newestFirst:
        results.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        break;
      case TeacherSort.oldestFirst:
        results.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
        break;
    }

    return results;
  });
});

final teacherMetricsProvider = Provider.autoDispose<AsyncValue<TeacherMetrics>>((ref) {
  final teachersAsync = ref.watch(teacherStreamProvider);
  return teachersAsync.whenData(TeacherMetrics.fromTeachers);
});
