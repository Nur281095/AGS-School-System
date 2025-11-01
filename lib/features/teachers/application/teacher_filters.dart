import 'package:flutter/material.dart';

import '../../../core/models/teacher.dart';

enum TeacherSort { alphabetical, newestFirst, oldestFirst }

extension TeacherSortX on TeacherSort {
  String get label {
    switch (this) {
      case TeacherSort.alphabetical:
        return 'Name (A-Z)';
      case TeacherSort.newestFirst:
        return 'Newest first';
      case TeacherSort.oldestFirst:
        return 'Oldest first';
    }
  }

  IconData get icon {
    switch (this) {
      case TeacherSort.alphabetical:
        return Icons.sort_by_alpha_rounded;
      case TeacherSort.newestFirst:
        return Icons.trending_up_rounded;
      case TeacherSort.oldestFirst:
        return Icons.trending_down_rounded;
    }
  }
}

class TeacherFilters {
  const TeacherFilters({
    this.query = '',
    this.status,
    this.sort = TeacherSort.alphabetical,
  });

  final String query;
  final TeacherStatus? status;
  final TeacherSort sort;

  TeacherFilters copyWith({String? query, TeacherStatus? status, TeacherSort? sort}) {
    return TeacherFilters(
      query: query ?? this.query,
      status: status ?? this.status,
      sort: sort ?? this.sort,
    );
  }

  bool get hasQuery => query.trim().isNotEmpty;
  bool get hasStatus => status != null;
}
