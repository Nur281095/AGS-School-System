import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/app_providers.dart';
import '../../../core/models/teacher.dart';
import '../../../data/repositories/teacher_repository.dart';

final teacherActionsProvider = Provider<TeacherActions>((ref) {
  final repository = ref.watch(teacherRepositoryProvider);
  return TeacherActions(repository);
});

class TeacherActions {
  TeacherActions(this._repository);

  final TeacherRepository _repository;

  Future<void> addTeacher(Teacher teacher) => _repository.createTeacher(teacher);

  Future<void> updateTeacher(Teacher teacher) {
    assert(teacher.id != null, 'Teacher id is required to update a record');
    return _repository.updateTeacher(teacher);
  }

  Future<void> deleteTeacher(int id) => _repository.deleteTeacher(id);
}
