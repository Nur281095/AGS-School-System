import 'package:equatable/equatable.dart';

enum TeacherStatus { active, inactive, archived }

extension TeacherStatusX on TeacherStatus {
  String get label {
    switch (this) {
      case TeacherStatus.active:
        return 'Active';
      case TeacherStatus.inactive:
        return 'Inactive';
      case TeacherStatus.archived:
        return 'Archived';
    }
  }
}

class Teacher extends Equatable {
  const Teacher({
    this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    this.cnic,
    this.hireDate,
    this.status = TeacherStatus.active,
  });

  final int? id;
  final String fullName;
  final String phone;
  final String email;
  final String? cnic;
  final DateTime? hireDate;
  final TeacherStatus status;

  bool get hasIdentifier => id != null;

  Teacher copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? email,
    String? cnic,
    DateTime? hireDate,
    TeacherStatus? status,
  }) {
    return Teacher(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      cnic: cnic ?? this.cnic,
      hireDate: hireDate ?? this.hireDate,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, fullName, phone, email, cnic, hireDate, status];
}
