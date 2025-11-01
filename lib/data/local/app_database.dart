import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/models/teacher.dart';
import 'daos/teacher_dao.dart';
part 'app_database.g.dart';

class Teachers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fullName => text()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  TextColumn get cnic => text().nullable()();
  DateTimeColumn get hireDate => dateTime().nullable()();
  IntColumn get status => intEnum<TeacherStatus>()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final dbFolder = Directory(p.join(dir.path, 'ags_school_system'));
    if (!dbFolder.existsSync()) {
      dbFolder.createSync(recursive: true);
    }
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [Teachers], daos: [TeacherDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> seed() async {
    final hasTeachers = await teacherDao.hasAnyTeachers();
    if (hasTeachers) {
      return;
    }

    await batch((batch) {
      batch.insertAll(teachers, [
        TeachersCompanion.insert(
          fullName: 'Aqeel Ahmed',
          phone: '+92 300 1234567',
          email: 'aqeel.ahmed@example.com',
          cnic: const Value('35202-1234567-1'),
          hireDate: Value(DateTime.now().subtract(const Duration(days: 320))),
          status: const Value(TeacherStatus.active),
        ),
        TeachersCompanion.insert(
          fullName: 'Madiha Khan',
          phone: '+92 333 7654321',
          email: 'madiha.khan@example.com',
          hireDate: Value(DateTime.now().subtract(const Duration(days: 150))),
          status: const Value(TeacherStatus.active),
        ),
        TeachersCompanion.insert(
          fullName: 'Rehan Siddiqui',
          phone: '+92 301 9988776',
          email: 'rehan.siddiqui@example.com',
          status: const Value(TeacherStatus.inactive),
        ),
      ]);
    });
  }
}
