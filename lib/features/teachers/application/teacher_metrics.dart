import '../../../core/models/teacher.dart';

class TeacherMetrics {
  const TeacherMetrics({
    required this.total,
    required this.active,
    required this.inactive,
    required this.archived,
  });

  final int total;
  final int active;
  final int inactive;
  final int archived;

  factory TeacherMetrics.fromTeachers(List<Teacher> teachers) {
    final grouped = <TeacherStatus, int>{
      TeacherStatus.active: 0,
      TeacherStatus.inactive: 0,
      TeacherStatus.archived: 0,
    };

    for (final teacher in teachers) {
      grouped.update(teacher.status, (value) => value + 1, ifAbsent: () => 1);
    }

    return TeacherMetrics(
      total: teachers.length,
      active: grouped[TeacherStatus.active] ?? 0,
      inactive: grouped[TeacherStatus.inactive] ?? 0,
      archived: grouped[TeacherStatus.archived] ?? 0,
    );
  }
}
