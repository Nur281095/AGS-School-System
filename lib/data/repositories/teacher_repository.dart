import 'package:drift/drift.dart';

import '../../core/models/teacher.dart';
import '../local/app_database.dart';
import '../local/daos/teacher_dao.dart';

abstract class TeacherRepository {
  Stream<List<Teacher>> watchTeachers({TeacherStatus? status, String? query});

  Future<void> createTeacher(Teacher teacher);

  Future<void> updateTeacher(Teacher teacher);

  Future<void> deleteTeacher(int id);
}

class DriftTeacherRepository implements TeacherRepository {
  DriftTeacherRepository(this._db) : _dao = _db.teacherDao;

  final AppDatabase _db;
  final TeacherDao _dao;

  @override
  Stream<List<Teacher>> watchTeachers({TeacherStatus? status, String? query}) {
    return _dao.watchTeachers(status: status, query: query);
  }

  @override
  Future<void> createTeacher(Teacher teacher) async {
    await _dao.createTeacher(TeachersCompanion.insert(
      fullName: teacher.fullName,
      phone: teacher.phone,
      email: teacher.email,
      cnic: Value(teacher.cnic),
      hireDate: Value(teacher.hireDate),
      status: Value(teacher.status),
    ));
  }

  @override
  Future<void> updateTeacher(Teacher teacher) {
    if (teacher.id == null) {
      throw ArgumentError('Teacher id is required for update operations');
    }
    return _dao.updateTeacher(
      TeachersCompanion(
        id: Value(teacher.id!),
        fullName: Value(teacher.fullName),
        phone: Value(teacher.phone),
        email: Value(teacher.email),
        cnic: Value(teacher.cnic),
        hireDate: Value(teacher.hireDate),
        status: Value(teacher.status),
      ),
    );
  }

  @override
  Future<void> deleteTeacher(int id) => _dao.deleteTeacherById(id);
}
