import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/app_providers.dart';
import '../../../core/models/teacher.dart';
import 'teacher_filters.dart';

final teacherFiltersProvider = StateProvider<TeacherFilters>((ref) {
  return const TeacherFilters();
});

final teacherListProvider = StreamProvider.autoDispose<List<Teacher>>((ref) {
  final filters = ref.watch(teacherFiltersProvider);
  final repository = ref.watch(teacherRepositoryProvider);
  return repository.watchTeachers(
    status: filters.status,
    query: filters.query.isEmpty ? null : filters.query,
  );
});
