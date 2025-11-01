import 'package:drift/drift.dart';

import '../../core/models/teacher.dart';
import '../app_database.dart';

part 'teacher_dao.g.dart';

@DriftAccessor(tables: [Teachers])
class TeacherDao extends DatabaseAccessor<AppDatabase> with _$TeacherDaoMixin {
  TeacherDao(AppDatabase db) : super(db);

  Stream<List<Teacher>> watchTeachers({
    TeacherStatus? status,
    String? query,
  }) {
    final builder = select(teachers);
    if (status != null) {
      builder.where((tbl) => tbl.status.equalsValue(status));
    }
    if (query != null && query.isNotEmpty) {
      final pattern = '%${query.toLowerCase()}%';
      builder.where(
        (tbl) => tbl.fullName.lower().like(pattern) | tbl.phone.lower().like(pattern),
      );
    }
    builder.orderBy([(tbl) => OrderingTerm.asc(tbl.fullName)]);
    return builder.watch().map((rows) => rows.map(_mapTeacher).toList());
  }

  Future<int> createTeacher(TeachersCompanion companion) => into(teachers).insert(companion);

  Future<bool> updateTeacher(TeachersCompanion companion) => update(teachers).replace(companion);

  Future<int> deleteTeacherById(int id) => (delete(teachers)..where((tbl) => tbl.id.equals(id))).go();

  Future<bool> hasAnyTeachers() async {
    final countExpr = teachers.id.count();
    final query = selectOnly(teachers)..addColumns([countExpr]);
    final result = await query.getSingle();
    return result.read(countExpr)! > 0;
  }

  Teacher _mapTeacher(TeacherData row) {
    return Teacher(
      id: row.id,
      fullName: row.fullName,
      phone: row.phone,
      email: row.email,
      cnic: row.cnic,
      hireDate: row.hireDate,
      status: row.status,
    );
  }
}
