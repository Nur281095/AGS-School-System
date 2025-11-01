import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/teacher.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../application/teacher_actions.dart';
import '../../dialogs/teacher_form_dialog.dart';

class TeacherTable extends ConsumerStatefulWidget {
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
  ConsumerState<TeacherTable> createState() => _TeacherTableState();
}

class _TeacherTableState extends ConsumerState<TeacherTable> {
  late final ScrollController _verticalController;
  late final ScrollController _horizontalController;

  @override
  void initState() {
    super.initState();
    _verticalController = ScrollController();
    _horizontalController = ScrollController();
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actions = ref.watch(teacherActionsProvider);
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: double.infinity,
            height: constraints.maxHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TableToolbar(count: widget.teachers.length),
                const Divider(height: 1),
                Expanded(
                  child: Scrollbar(
                    controller: _verticalController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _verticalController,
                      child: Scrollbar(
                        controller: _horizontalController,
                        thumbVisibility: widget.teachers.length > 4,
                        notificationPredicate: (notification) => notification.depth == 1,
                        child: SingleChildScrollView(
                          controller: _horizontalController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable2(
                            dataRowMinHeight: 72,
                            dataRowMaxHeight: 88,
                            columnSpacing: 24,
                            horizontalMargin: 24,
                            headingRowColor: MaterialStateProperty.resolveWith(
                              (states) => theme.colorScheme.primary.withOpacity(0.05),
                            ),
                            headingTextStyle: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: .2,
                            ),
                            columns: const [
                              DataColumn2(label: Text('Teacher'), size: ColumnSize.L),
                              DataColumn(label: Text('Contact')), 
                              DataColumn(label: Text('Hire date')),
                              DataColumn(label: Text('Status')),
                              DataColumn2(label: Text('Actions'), fixedWidth: 120),
                            ],
                            rows: widget.teachers.map((teacher) {
                              return DataRow2(
                                specificRowHeight: 80,
                                color: MaterialStateProperty.resolveWith(
                                  (states) => teacher.status == TeacherStatus.inactive
                                      ? theme.colorScheme.surfaceVariant.withOpacity(0.22)
                                      : null,
                                ),
                                cells: [
                                  DataCell(_TeacherIdentityCell(teacher: teacher)),
                                  DataCell(_ContactCell(teacher: teacher)),
                                  DataCell(_HireDateCell(teacher: teacher)),
                                  DataCell(_StatusBadge(status: teacher.status)),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: _RowActions(
                                        teacher: teacher,
                                        actions: actions,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TableToolbar extends StatelessWidget {
  const _TableToolbar({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Faculty directory',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                '$count ${count == 1 ? 'teacher' : 'teachers'} on record',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: () => TeacherTable.showCreateDialog(context),
            icon: const Icon(Icons.person_add_alt_rounded),
            label: const Text('New teacher'),
          ),
        ],
      ),
    );
  }
}

class _TeacherIdentityCell extends StatelessWidget {
  const _TeacherIdentityCell({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final identifier = teacher.hasIdentifier
        ? '#${teacher.id!.toString().padLeft(4, '0')}'
        : 'Draft';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Text(
            teacher.fullName.isNotEmpty ? teacher.fullName[0].toUpperCase() : '?',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      teacher.fullName,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (!teacher.hasIdentifier) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Unsaved',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                identifier,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactCell extends StatelessWidget {
  const _ContactCell({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(teacher.phone, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          teacher.email,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (teacher.cnic != null && teacher.cnic!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'CNIC: ${teacher.cnic}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _HireDateCell extends StatelessWidget {
  const _HireDateCell({required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = teacher.hireDate;

    if (date == null) {
      return Text('Not set', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant));
    }

    final formatted = DateFormatters.display.format(date);
    final years = DateTime.now().difference(date).inDays ~/ 365;
    final tenureLabel = years > 0 ? '$years yr${years == 1 ? '' : 's'} tenure' : 'Hired this year';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(formatted, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(
          tenureLabel,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final TeacherStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    late final Color color;
    late final Color background;

    switch (status) {
      case TeacherStatus.active:
        color = const Color(0xFF22C55E);
        background = const Color(0xFFDCFCE7);
        break;
      case TeacherStatus.inactive:
        color = const Color(0xFFF59E0B);
        background = const Color(0xFFFDF4E7);
        break;
      case TeacherStatus.archived:
        color = theme.colorScheme.error;
        background = theme.colorScheme.error.withOpacity(0.12);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 8),
          Text(
            status.label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RowActions extends StatelessWidget {
  const _RowActions({required this.teacher, required this.actions});

  final Teacher teacher;
  final TeacherActions actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MenuAnchor(
      builder: (context, controller, child) {
        return FilledButton.tonalIcon(
          onPressed: teacher.hasIdentifier ? controller.toggle : null,
          icon: const Icon(Icons.more_horiz),
          label: const Text('Manage'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.edit_outlined),
          onPressed: teacher.hasIdentifier
              ? () {
                  TeacherTable.showEditDialog(context, teacher);
                }
              : null,
          child: const Text('Edit details'),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete_outline),
          onPressed: teacher.hasIdentifier
              ? () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete teacher'),
                      content: Text(
                        'Delete ${teacher.fullName}? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if ((confirmed ?? false) && teacher.id != null) {
                    await actions.deleteTeacher(teacher.id!);
                  }
                }
              : null,
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
