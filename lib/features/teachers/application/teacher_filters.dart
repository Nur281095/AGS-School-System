import '../../../core/models/teacher.dart';

class TeacherFilters {
  const TeacherFilters({this.query = '', this.status});

  final String query;
  final TeacherStatus? status;

  TeacherFilters copyWith({String? query, TeacherStatus? status}) {
    return TeacherFilters(
      query: query ?? this.query,
      status: status ?? this.status,
    );
  }

  bool get hasQuery => query.trim().isNotEmpty;
}
