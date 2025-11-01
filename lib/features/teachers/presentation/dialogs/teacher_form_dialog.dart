import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/teacher.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../application/teacher_actions.dart';

class TeacherFormDialog extends ConsumerStatefulWidget {
  const TeacherFormDialog({this.teacher, super.key});

  final Teacher? teacher;

  bool get isEditing => teacher != null;

  @override
  ConsumerState<TeacherFormDialog> createState() => _TeacherFormDialogState();
}

class _TeacherFormDialogState extends ConsumerState<TeacherFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _cnicController;
  DateTime? _hireDate;
  TeacherStatus _status = TeacherStatus.active;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final teacher = widget.teacher;
    _nameController = TextEditingController(text: teacher?.fullName ?? '');
    _phoneController = TextEditingController(text: teacher?.phone ?? '');
    _emailController = TextEditingController(text: teacher?.email ?? '');
    _cnicController = TextEditingController(text: teacher?.cnic ?? '');
    _hireDate = teacher?.hireDate;
    _status = teacher?.status ?? TeacherStatus.active;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cnicController.dispose();
    super.dispose();
  }

  Future<void> _pickHireDate() async {
    final now = DateTime.now();
    final initial = _hireDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 20),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() => _hireDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isSaving = true);
    final actions = ref.read(teacherActionsProvider);
    final teacher = Teacher(
      id: widget.teacher?.id,
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      cnic: _cnicController.text.trim().isEmpty ? null : _cnicController.text.trim(),
      hireDate: _hireDate,
      status: _status,
    );
    try {
      if (widget.isEditing) {
        if (!teacher.hasIdentifier) {
          throw StateError('Cannot update a teacher without an identifier');
        }
        await actions.updateTeacher(teacher);
      } else {
        await actions.addTeacher(teacher);
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.isEditing ? 'Edit teacher' : 'Create new teacher';

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 640),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            children: [
              _DialogHeader(title: title, teacher: widget.teacher),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal information',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),
                        _FieldRow(children: [
                          _TextField(
                            controller: _nameController,
                            label: 'Full name *',
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                          ),
                        ]),
                        const SizedBox(height: 20),
                        _FieldRow(children: [
                          _TextField(
                            controller: _phoneController,
                            label: 'Phone number *',
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Phone number is required';
                              }
                              return null;
                            },
                          ),
                          _TextField(
                            controller: _emailController,
                            label: 'Email address *',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              final trimmed = value.trim();
                              if (!trimmed.contains('@') || !trimmed.contains('.')) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ]),
                        const SizedBox(height: 20),
                        _FieldRow(children: [
                          _TextField(
                            controller: _cnicController,
                            label: 'CNIC / ID (optional)',
                          ),
                          _DateField(
                            label: 'Hire date',
                            value: _hireDate,
                            onPressed: _pickHireDate,
                          ),
                        ]),
                        const SizedBox(height: 28),
                        Text(
                          'Availability status',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton<TeacherStatus>(
                          segments: TeacherStatus.values
                              .map(
                                (status) => ButtonSegment<TeacherStatus>(
                                  value: status,
                                  label: Text(status.label),
                                  icon: Icon(_statusIcon(status)),
                                ),
                              )
                              .toList(),
                          selected: <TeacherStatus>{_status},
                          onSelectionChanged: (selection) {
                            setState(() => _status = selection.first);
                          },
                        ),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline, color: theme.colorScheme.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Teacher profiles stay offline-ready. Keep contact details and status up to date before generating challans or schedules.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSaving ? null : () => Navigator.of(context).maybePop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _isSaving ? null : _submit,
                      child: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(widget.isEditing ? 'Save changes' : 'Create teacher'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _statusIcon(TeacherStatus status) {
    switch (status) {
      case TeacherStatus.active:
        return Icons.verified_user_outlined;
      case TeacherStatus.inactive:
        return Icons.pause_circle_outline;
      case TeacherStatus.archived:
        return Icons.archive_outlined;
    }
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.title, required this.teacher});

  final String title;
  final Teacher? teacher;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
            child: Icon(Icons.person_outline, color: theme.colorScheme.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                teacher?.fullName ?? 'Fill in the details below to add a faculty member.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (teacher?.hasIdentifier ?? false)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '#${teacher!.id!.toString().padLeft(4, '0')}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.length == 1) {
      return children.first;
    }
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i != children.length - 1) const SizedBox(width: 20),
        ],
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.calendar_today_outlined),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 4),
              Text(
                value == null ? 'Select date' : DateFormatters.display.format(value!),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
