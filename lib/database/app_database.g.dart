// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AlarmTableTable extends AlarmTable
    with TableInfo<$AlarmTableTable, AlarmTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> repeat =
      GeneratedColumn<String>('repeat', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($AlarmTableTable.$converterrepeat);
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'));
  static const VerificationMeta _soundMeta = const VerificationMeta('sound');
  @override
  late final GeneratedColumn<String> sound = GeneratedColumn<String>(
      'sound', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _snoozeMeta = const VerificationMeta('snooze');
  @override
  late final GeneratedColumn<bool> snooze = GeneratedColumn<bool>(
      'snooze', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("snooze" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, label, repeat, time, isActive, sound, snooze];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarm_table';
  @override
  VerificationContext validateIntegrity(Insertable<AlarmTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('sound')) {
      context.handle(
          _soundMeta, sound.isAcceptableOrUnknown(data['sound']!, _soundMeta));
    } else if (isInserting) {
      context.missing(_soundMeta);
    }
    if (data.containsKey('snooze')) {
      context.handle(_snoozeMeta,
          snooze.isAcceptableOrUnknown(data['snooze']!, _snoozeMeta));
    } else if (isInserting) {
      context.missing(_snoozeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlarmTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlarmTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      repeat: $AlarmTableTable.$converterrepeat.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repeat'])!),
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      sound: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sound'])!,
      snooze: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}snooze'])!,
    );
  }

  @override
  $AlarmTableTable createAlias(String alias) {
    return $AlarmTableTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterrepeat =
      const StringListConverter();
}

class AlarmTableData extends DataClass implements Insertable<AlarmTableData> {
  final int id;
  final String label;
  final List<String> repeat;
  final String time;
  final bool isActive;
  final String sound;
  final bool snooze;
  const AlarmTableData(
      {required this.id,
      required this.label,
      required this.repeat,
      required this.time,
      required this.isActive,
      required this.sound,
      required this.snooze});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    {
      map['repeat'] =
          Variable<String>($AlarmTableTable.$converterrepeat.toSql(repeat));
    }
    map['time'] = Variable<String>(time);
    map['is_active'] = Variable<bool>(isActive);
    map['sound'] = Variable<String>(sound);
    map['snooze'] = Variable<bool>(snooze);
    return map;
  }

  AlarmTableCompanion toCompanion(bool nullToAbsent) {
    return AlarmTableCompanion(
      id: Value(id),
      label: Value(label),
      repeat: Value(repeat),
      time: Value(time),
      isActive: Value(isActive),
      sound: Value(sound),
      snooze: Value(snooze),
    );
  }

  factory AlarmTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlarmTableData(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      repeat: serializer.fromJson<List<String>>(json['repeat']),
      time: serializer.fromJson<String>(json['time']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sound: serializer.fromJson<String>(json['sound']),
      snooze: serializer.fromJson<bool>(json['snooze']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'repeat': serializer.toJson<List<String>>(repeat),
      'time': serializer.toJson<String>(time),
      'isActive': serializer.toJson<bool>(isActive),
      'sound': serializer.toJson<String>(sound),
      'snooze': serializer.toJson<bool>(snooze),
    };
  }

  AlarmTableData copyWith(
          {int? id,
          String? label,
          List<String>? repeat,
          String? time,
          bool? isActive,
          String? sound,
          bool? snooze}) =>
      AlarmTableData(
        id: id ?? this.id,
        label: label ?? this.label,
        repeat: repeat ?? this.repeat,
        time: time ?? this.time,
        isActive: isActive ?? this.isActive,
        sound: sound ?? this.sound,
        snooze: snooze ?? this.snooze,
      );
  AlarmTableData copyWithCompanion(AlarmTableCompanion data) {
    return AlarmTableData(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      repeat: data.repeat.present ? data.repeat.value : this.repeat,
      time: data.time.present ? data.time.value : this.time,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sound: data.sound.present ? data.sound.value : this.sound,
      snooze: data.snooze.present ? data.snooze.value : this.snooze,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlarmTableData(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('repeat: $repeat, ')
          ..write('time: $time, ')
          ..write('isActive: $isActive, ')
          ..write('sound: $sound, ')
          ..write('snooze: $snooze')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, label, repeat, time, isActive, sound, snooze);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlarmTableData &&
          other.id == this.id &&
          other.label == this.label &&
          other.repeat == this.repeat &&
          other.time == this.time &&
          other.isActive == this.isActive &&
          other.sound == this.sound &&
          other.snooze == this.snooze);
}

class AlarmTableCompanion extends UpdateCompanion<AlarmTableData> {
  final Value<int> id;
  final Value<String> label;
  final Value<List<String>> repeat;
  final Value<String> time;
  final Value<bool> isActive;
  final Value<String> sound;
  final Value<bool> snooze;
  const AlarmTableCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.repeat = const Value.absent(),
    this.time = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sound = const Value.absent(),
    this.snooze = const Value.absent(),
  });
  AlarmTableCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    required List<String> repeat,
    required String time,
    required bool isActive,
    required String sound,
    required bool snooze,
  })  : label = Value(label),
        repeat = Value(repeat),
        time = Value(time),
        isActive = Value(isActive),
        sound = Value(sound),
        snooze = Value(snooze);
  static Insertable<AlarmTableData> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<String>? repeat,
    Expression<String>? time,
    Expression<bool>? isActive,
    Expression<String>? sound,
    Expression<bool>? snooze,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (repeat != null) 'repeat': repeat,
      if (time != null) 'time': time,
      if (isActive != null) 'is_active': isActive,
      if (sound != null) 'sound': sound,
      if (snooze != null) 'snooze': snooze,
    });
  }

  AlarmTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? label,
      Value<List<String>>? repeat,
      Value<String>? time,
      Value<bool>? isActive,
      Value<String>? sound,
      Value<bool>? snooze}) {
    return AlarmTableCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      repeat: repeat ?? this.repeat,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      sound: sound ?? this.sound,
      snooze: snooze ?? this.snooze,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<String>(
          $AlarmTableTable.$converterrepeat.toSql(repeat.value));
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sound.present) {
      map['sound'] = Variable<String>(sound.value);
    }
    if (snooze.present) {
      map['snooze'] = Variable<bool>(snooze.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmTableCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('repeat: $repeat, ')
          ..write('time: $time, ')
          ..write('isActive: $isActive, ')
          ..write('sound: $sound, ')
          ..write('snooze: $snooze')
          ..write(')'))
        .toString();
  }
}

class $TaskTableTable extends TaskTable
    with TableInfo<$TaskTableTable, TaskTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reminderMeta =
      const VerificationMeta('reminder');
  @override
  late final GeneratedColumn<DateTime> reminder = GeneratedColumn<DateTime>(
      'reminder', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
      'is_done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_done" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, title, note, reminder, isDone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_table';
  @override
  VerificationContext validateIntegrity(Insertable<TaskTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('reminder')) {
      context.handle(_reminderMeta,
          reminder.isAcceptableOrUnknown(data['reminder']!, _reminderMeta));
    }
    if (data.containsKey('is_done')) {
      context.handle(_isDoneMeta,
          isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta));
    } else if (isInserting) {
      context.missing(_isDoneMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      reminder: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}reminder']),
      isDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_done'])!,
    );
  }

  @override
  $TaskTableTable createAlias(String alias) {
    return $TaskTableTable(attachedDatabase, alias);
  }
}

class TaskTableData extends DataClass implements Insertable<TaskTableData> {
  final int id;
  final String title;
  final String note;
  final DateTime? reminder;
  final bool isDone;
  const TaskTableData(
      {required this.id,
      required this.title,
      required this.note,
      this.reminder,
      required this.isDone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || reminder != null) {
      map['reminder'] = Variable<DateTime>(reminder);
    }
    map['is_done'] = Variable<bool>(isDone);
    return map;
  }

  TaskTableCompanion toCompanion(bool nullToAbsent) {
    return TaskTableCompanion(
      id: Value(id),
      title: Value(title),
      note: Value(note),
      reminder: reminder == null && nullToAbsent
          ? const Value.absent()
          : Value(reminder),
      isDone: Value(isDone),
    );
  }

  factory TaskTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String>(json['note']),
      reminder: serializer.fromJson<DateTime?>(json['reminder']),
      isDone: serializer.fromJson<bool>(json['isDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String>(note),
      'reminder': serializer.toJson<DateTime?>(reminder),
      'isDone': serializer.toJson<bool>(isDone),
    };
  }

  TaskTableData copyWith(
          {int? id,
          String? title,
          String? note,
          Value<DateTime?> reminder = const Value.absent(),
          bool? isDone}) =>
      TaskTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        note: note ?? this.note,
        reminder: reminder.present ? reminder.value : this.reminder,
        isDone: isDone ?? this.isDone,
      );
  TaskTableData copyWithCompanion(TaskTableCompanion data) {
    return TaskTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      reminder: data.reminder.present ? data.reminder.value : this.reminder,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('reminder: $reminder, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, note, reminder, isDone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.note == this.note &&
          other.reminder == this.reminder &&
          other.isDone == this.isDone);
}

class TaskTableCompanion extends UpdateCompanion<TaskTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> note;
  final Value<DateTime?> reminder;
  final Value<bool> isDone;
  const TaskTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.reminder = const Value.absent(),
    this.isDone = const Value.absent(),
  });
  TaskTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String note,
    this.reminder = const Value.absent(),
    required bool isDone,
  })  : title = Value(title),
        note = Value(note),
        isDone = Value(isDone);
  static Insertable<TaskTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? note,
    Expression<DateTime>? reminder,
    Expression<bool>? isDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (reminder != null) 'reminder': reminder,
      if (isDone != null) 'is_done': isDone,
    });
  }

  TaskTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? note,
      Value<DateTime?>? reminder,
      Value<bool>? isDone}) {
    return TaskTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      reminder: reminder ?? this.reminder,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (reminder.present) {
      map['reminder'] = Variable<DateTime>(reminder.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('reminder: $reminder, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AlarmTableTable alarmTable = $AlarmTableTable(this);
  late final $TaskTableTable taskTable = $TaskTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [alarmTable, taskTable];
}

typedef $$AlarmTableTableCreateCompanionBuilder = AlarmTableCompanion Function({
  Value<int> id,
  required String label,
  required List<String> repeat,
  required String time,
  required bool isActive,
  required String sound,
  required bool snooze,
});
typedef $$AlarmTableTableUpdateCompanionBuilder = AlarmTableCompanion Function({
  Value<int> id,
  Value<String> label,
  Value<List<String>> repeat,
  Value<String> time,
  Value<bool> isActive,
  Value<String> sound,
  Value<bool> snooze,
});

class $$AlarmTableTableFilterComposer
    extends Composer<_$AppDatabase, $AlarmTableTable> {
  $$AlarmTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get repeat => $composableBuilder(
          column: $table.repeat,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sound => $composableBuilder(
      column: $table.sound, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get snooze => $composableBuilder(
      column: $table.snooze, builder: (column) => ColumnFilters(column));
}

class $$AlarmTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AlarmTableTable> {
  $$AlarmTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get repeat => $composableBuilder(
      column: $table.repeat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sound => $composableBuilder(
      column: $table.sound, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get snooze => $composableBuilder(
      column: $table.snooze, builder: (column) => ColumnOrderings(column));
}

class $$AlarmTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlarmTableTable> {
  $$AlarmTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get repeat =>
      $composableBuilder(column: $table.repeat, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get sound =>
      $composableBuilder(column: $table.sound, builder: (column) => column);

  GeneratedColumn<bool> get snooze =>
      $composableBuilder(column: $table.snooze, builder: (column) => column);
}

class $$AlarmTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlarmTableTable,
    AlarmTableData,
    $$AlarmTableTableFilterComposer,
    $$AlarmTableTableOrderingComposer,
    $$AlarmTableTableAnnotationComposer,
    $$AlarmTableTableCreateCompanionBuilder,
    $$AlarmTableTableUpdateCompanionBuilder,
    (
      AlarmTableData,
      BaseReferences<_$AppDatabase, $AlarmTableTable, AlarmTableData>
    ),
    AlarmTableData,
    PrefetchHooks Function()> {
  $$AlarmTableTableTableManager(_$AppDatabase db, $AlarmTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlarmTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlarmTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlarmTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<List<String>> repeat = const Value.absent(),
            Value<String> time = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> sound = const Value.absent(),
            Value<bool> snooze = const Value.absent(),
          }) =>
              AlarmTableCompanion(
            id: id,
            label: label,
            repeat: repeat,
            time: time,
            isActive: isActive,
            sound: sound,
            snooze: snooze,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String label,
            required List<String> repeat,
            required String time,
            required bool isActive,
            required String sound,
            required bool snooze,
          }) =>
              AlarmTableCompanion.insert(
            id: id,
            label: label,
            repeat: repeat,
            time: time,
            isActive: isActive,
            sound: sound,
            snooze: snooze,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AlarmTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlarmTableTable,
    AlarmTableData,
    $$AlarmTableTableFilterComposer,
    $$AlarmTableTableOrderingComposer,
    $$AlarmTableTableAnnotationComposer,
    $$AlarmTableTableCreateCompanionBuilder,
    $$AlarmTableTableUpdateCompanionBuilder,
    (
      AlarmTableData,
      BaseReferences<_$AppDatabase, $AlarmTableTable, AlarmTableData>
    ),
    AlarmTableData,
    PrefetchHooks Function()>;
typedef $$TaskTableTableCreateCompanionBuilder = TaskTableCompanion Function({
  Value<int> id,
  required String title,
  required String note,
  Value<DateTime?> reminder,
  required bool isDone,
});
typedef $$TaskTableTableUpdateCompanionBuilder = TaskTableCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> note,
  Value<DateTime?> reminder,
  Value<bool> isDone,
});

class $$TaskTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaskTableTable> {
  $$TaskTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get reminder => $composableBuilder(
      column: $table.reminder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnFilters(column));
}

class $$TaskTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskTableTable> {
  $$TaskTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get reminder => $composableBuilder(
      column: $table.reminder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnOrderings(column));
}

class $$TaskTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskTableTable> {
  $$TaskTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get reminder =>
      $composableBuilder(column: $table.reminder, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);
}

class $$TaskTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskTableTable,
    TaskTableData,
    $$TaskTableTableFilterComposer,
    $$TaskTableTableOrderingComposer,
    $$TaskTableTableAnnotationComposer,
    $$TaskTableTableCreateCompanionBuilder,
    $$TaskTableTableUpdateCompanionBuilder,
    (
      TaskTableData,
      BaseReferences<_$AppDatabase, $TaskTableTable, TaskTableData>
    ),
    TaskTableData,
    PrefetchHooks Function()> {
  $$TaskTableTableTableManager(_$AppDatabase db, $TaskTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<DateTime?> reminder = const Value.absent(),
            Value<bool> isDone = const Value.absent(),
          }) =>
              TaskTableCompanion(
            id: id,
            title: title,
            note: note,
            reminder: reminder,
            isDone: isDone,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String note,
            Value<DateTime?> reminder = const Value.absent(),
            required bool isDone,
          }) =>
              TaskTableCompanion.insert(
            id: id,
            title: title,
            note: note,
            reminder: reminder,
            isDone: isDone,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskTableTable,
    TaskTableData,
    $$TaskTableTableFilterComposer,
    $$TaskTableTableOrderingComposer,
    $$TaskTableTableAnnotationComposer,
    $$TaskTableTableCreateCompanionBuilder,
    $$TaskTableTableUpdateCompanionBuilder,
    (
      TaskTableData,
      BaseReferences<_$AppDatabase, $TaskTableTable, TaskTableData>
    ),
    TaskTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AlarmTableTableTableManager get alarmTable =>
      $$AlarmTableTableTableManager(_db, _db.alarmTable);
  $$TaskTableTableTableManager get taskTable =>
      $$TaskTableTableTableManager(_db, _db.taskTable);
}
