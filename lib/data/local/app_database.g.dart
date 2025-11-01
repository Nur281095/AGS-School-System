// GENERATED CODE - MANUALLY MAINTAINED UNTIL build_runner IS EXECUTED.
// ignore_for_file: type=lint
part of 'app_database.dart';

class TeacherData extends DataClass implements Insertable<TeacherData> {
  const TeacherData({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    this.cnic,
    this.hireDate,
    required this.status,
  });

  final int id;
  final String fullName;
  final String phone;
  final String email;
  final String? cnic;
  final DateTime? hireDate;
  final TeacherStatus status;

  @override
  Map<String, Expression<Object?>> toColumns(bool nullToAbsent) {
    final map = <String, Expression<Object?>>{};
    map['id'] = Variable<int>(id);
    map['full_name'] = Variable<String>(fullName);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || cnic != null) {
      map['cnic'] = Variable<String?>(cnic);
    }
    if (!nullToAbsent || hireDate != null) {
      map['hire_date'] = Variable<DateTime?>(hireDate);
    }
    map['status'] = Variable<int>($TeachersTable.$converterstatus.toSql(status));
    return map;
  }

  TeachersCompanion toCompanion(bool nullToAbsent) {
    return TeachersCompanion(
      id: Value(id),
      fullName: Value(fullName),
      phone: Value(phone),
      email: Value(email),
      cnic: cnic == null && nullToAbsent ? const Value.absent() : Value(cnic),
      hireDate:
          hireDate == null && nullToAbsent ? const Value.absent() : Value(hireDate),
      status: Value(status),
    );
  }
}

class TeachersCompanion extends UpdateCompanion<TeacherData> {
  const TeachersCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.cnic = const Value.absent(),
    this.hireDate = const Value.absent(),
    this.status = const Value.absent(),
  });

  const TeachersCompanion.insert({
    this.id = const Value.absent(),
    required String fullName,
    required String phone,
    required String email,
    Value<String?> cnic = const Value.absent(),
    Value<DateTime?> hireDate = const Value.absent(),
    Value<TeacherStatus> status = const Value(TeacherStatus.active),
  })  : fullName = Value(fullName),
        phone = Value(phone),
        email = Value(email),
        cnic = cnic,
        hireDate = hireDate,
        status = status;

  final Value<int> id;
  final Value<String> fullName;
  final Value<String> phone;
  final Value<String> email;
  final Value<String?> cnic;
  final Value<DateTime?> hireDate;
  final Value<TeacherStatus> status;

  @override
  Map<String, Expression<Object?>> toColumns(bool nullToAbsent) {
    final map = <String, Expression<Object?>>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (cnic.present) {
      map['cnic'] = Variable<String?>(cnic.value);
    }
    if (hireDate.present) {
      map['hire_date'] = Variable<DateTime?>(hireDate.value);
    }
    if (status.present) {
      map['status'] =
          Variable<int>($TeachersTable.$converterstatus.toSql(status.value));
    }
    return map;
  }
}

class $TeachersTable extends Teachers with TableInfo<$TeachersTable, TeacherData> {
  $TeachersTable(this.attachedDatabase, [this._alias]);

  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  static const VerificationMeta _idMeta = VerificationMeta('id');
  static const VerificationMeta _fullNameMeta = VerificationMeta('fullName');
  static const VerificationMeta _phoneMeta = VerificationMeta('phone');
  static const VerificationMeta _emailMeta = VerificationMeta('email');
  static const VerificationMeta _cnicMeta = VerificationMeta('cnic');
  static const VerificationMeta _hireDateMeta = VerificationMeta('hireDate');
  static const VerificationMeta _statusMeta = VerificationMeta('status');

  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );

  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  @override
  late final GeneratedColumn<String?> cnic = GeneratedColumn<String?>(
    'cnic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );

  @override
  late final GeneratedColumn<DateTime?> hireDate = GeneratedColumn<DateTime?>(
    'hire_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );

  @override
  late final GeneratedColumnWithTypeConverter<TeacherStatus, int> status =
      GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  ).withConverter<TeacherStatus>($TeachersTable.$converterstatus);

  @override
  List<GeneratedColumn> get $columns => [id, fullName, phone, email, cnic, hireDate, status];

  @override
  String get aliasedName => _alias ?? 'teachers';

  @override
  String get actualTableName => 'teachers';

  static const EnumIndexConverter<TeacherStatus> $converterstatus =
      EnumIndexConverter<TeacherStatus>(TeacherStatus.values);

  @override
  VerificationContext validateIntegrity(Insertable<TeacherData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(
        _idMeta,
        const VerificationResult.success(),
      );
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('cnic')) {
      context.handle(
        _cnicMeta,
        cnic.isAcceptableOrUnknown(data['cnic']!, _cnicMeta),
      );
    }
    if (data.containsKey('hire_date')) {
      context.handle(
        _hireDateMeta,
        hireDate.isAcceptableOrUnknown(data['hire_date']!, _hireDateMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  TeacherData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeacherData(
      id: attachedDatabase.typeMapping
          .read<int>(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fullName: attachedDatabase.typeMapping
          .read<String>(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      phone: attachedDatabase.typeMapping
          .read<String>(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      email: attachedDatabase.typeMapping
          .read<String>(DriftSqlType.string, data['${effectivePrefix}email'])!,
      cnic: attachedDatabase.typeMapping
          .readNullable<String>(DriftSqlType.string, data['${effectivePrefix}cnic']),
      hireDate: attachedDatabase.typeMapping.readNullable<DateTime>(
          DriftSqlType.dateTime, data['${effectivePrefix}hire_date']),
      status: $TeachersTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read<int>(DriftSqlType.int, data['${effectivePrefix}status'])!),
    );
  }

  @override
  $TeachersTable createAlias(String alias) {
    return $TeachersTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);

  late final $TeachersTable teachers = $TeachersTable(this);

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [teachers];

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => [teachers];
}
