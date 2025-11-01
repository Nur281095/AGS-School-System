import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';
import '../../data/repositories/teacher_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final teacherRepositoryProvider = Provider<TeacherRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftTeacherRepository(db);
});

final databaseInitializerProvider = FutureProvider<void>((ref) async {
  final db = ref.read(databaseProvider);
  await db.seed();
});
