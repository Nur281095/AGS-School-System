import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/teacher.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../application/teacher_actions.dart';
import '../../dialogs/teacher_form_dialog.dart';

class TeacherTable extends ConsumerWidget {
  const TeacherTable({required this.teachers, super.key});

  final List<Teacher> teachers;

  static Future<void> showCreateDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const TeacherFormDialog(),
    );
  }

  static Future<void> showEditDialog(BuildContext context, Teacher teacher) {
    return showDialog<void>(
      context: context,
      builder: (context) => TeacherFormDialog(teacher: teacher),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.watch(teacherActionsProvider);

    return DataTable2(
      columnSpacing: 24,
      horizontalMargin: 24,
      headingRowColor: MaterialStateProperty.all(
        Theme.of(context).colorScheme.primary.withOpacity(0.06),
      ),
      columns: const [
        DataColumn2(label: Text('Teacher'), size: ColumnSize.L),
        DataColumn(label: Text('Contact')),
        DataColumn(label: Text('CNIC/ID')),
        DataColumn(label: Text('Hire date')),
        DataColumn(label: Text('Status')),
        DataColumn2(label: Text('Actions'), size: ColumnSize.S),
      ],
      rows: teachers.map((teacher) {
        return DataRow2(
          cells: [
            DataCell(_TeacherIdentityCell(teacher: teacher)),
            DataCell(Text('${teacher.phone}\n${teacher.email}')),
            DataCell(Text(teacher.cnic ?? '—')),
            DataCell(Text(
              teacher.hireDate != null
                  ? DateFormatters.display.format(teacher.hireDate!)
                  : '—',
            )),
            DataCell(_StatusChip(status: teacher.status)),
            DataCell(Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Edit teacher',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: teacher.hasIdentifier
                      ? () => showEditDialog(context, teacher)
                      : null,
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: 'Delete teacher',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: teacher.hasIdentifier
                      ? () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete teacher'),
                              content: Text(
                                'Are you sure you want to delete ${teacher.fullName}?\nThis action cannot be undone.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if ((confirmed ?? false) && teacher.hasIdentifier) {
                            await actions.deleteTeacher(teacher.id!);
                          }
                        }
                      : null,
                ),
              ],
            )),
          ],
        );
      }).toList(),
    );
  }
}

class _TeacherIdentityCell extends StatelessWidget {
  const _TeacherIdentityCell({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    final identifier = teacher.hasIdentifier
        ? '#${teacher.id!.toString().padLeft(4, '0')}'
        : 'Draft';

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          child: Text(
            teacher.fullName.isNotEmpty ? teacher.fullName[0].toUpperCase() : '?',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                teacher.fullName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                identifier,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final TeacherStatus status;

  Color _backgroundColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (status) {
      case TeacherStatus.active:
        return scheme.primary.withOpacity(0.12);
      case TeacherStatus.inactive:
        return scheme.tertiary.withOpacity(0.12);
      case TeacherStatus.archived:
        return scheme.error.withOpacity(0.1);
    }
  }

  Color _foregroundColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (status) {
      case TeacherStatus.active:
        return scheme.primary;
      case TeacherStatus.inactive:
        return scheme.tertiary;
      case TeacherStatus.archived:
        return scheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: _foregroundColor(context),
            ),
      ),
    );
  }
}
