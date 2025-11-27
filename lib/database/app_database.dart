import 'package:drift/drift.dart';
import 'package:wakeup_app/database/tables.dart';
import 'package:wakeup_app/models/data_models.dart';
import 'connectors/connection.dart' as impl;
import 'converters/string_list_converter.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [AlarmTable, TaskTable])
class AppDatabase extends _$AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();

  AppDatabase._internal()
      : super(LazyDatabase(() async {
          return await impl.openConnection();
        }));

  @override
  int get schemaVersion => 1;

  // ========== ALARMES ==========

  Future<int> insertAlarm(Alarm data) async {
    await Future.delayed(const Duration(seconds: 3));

    return into(alarmTable).insert(
      AlarmTableCompanion(
          label: Value(data.label),
          time: Value(data.time),
          repeat: Value(data.repeat),
          isActive: Value(data.isActive),
          snooze: Value(data.snooze),
          sound: Value(data.sound)
      ),
    );
  }

  Future<List<Alarm>> getAllAlarms() async {
    final alarms = await select(alarmTable).get();
    final mappedAlarms = alarms.map((a) => Alarm(
        id: a.id,
        snooze: a.snooze,
        isActive: a.isActive,
        label: a.label,
        repeat: a.repeat,
        sound: a.sound,
        time: a.time));

    return mappedAlarms.toList();
  }

  Future<int> toggleAlarm(int id, bool newValue) async {
    return (update(alarmTable)..where((a) => a.id.equals(id)))
        .write(AlarmTableCompanion(
          isActive: Value(newValue),
        )
    );
  }

  Future<int> updateAlarm(int id, Alarm data) async {
    return (update(alarmTable)..where((a) => a.id.equals(id)))
        .write(AlarmTableCompanion(
      label: Value(data.label),
      time: Value(data.time),
      snooze: Value(data.snooze)
    )
    );
  }

  Future<int> deleteAlarm(int id) async {
    await Future.delayed(const Duration(seconds: 3));

    return (delete(alarmTable)..where((a) => a.id.equals(id))).go();
  }


  // ========== TAREFAS ==========

  Future<int> insertTask(Task data) async {
    await Future.delayed(const Duration(seconds: 3));

    return into(taskTable).insert(
      TaskTableCompanion(
        isDone: Value(data.isDone),
        note: Value(data.note),
        reminder: Value(data.reminder),
        title: Value(data.title)
      ),
    );
  }

  Future<List<Task>> getAllTasks() async {
    final tasks = await select(taskTable).get();
    final mappedTasks = tasks.map((t) => Task(
        id: t.id,
        note: t.note,
        title: t.title,
        isDone: t.isDone,
        reminder: t.reminder));

    return mappedTasks.toList();
  }

  Future<int> toggleTask(int id, bool newValue) async {
    return (update(taskTable)..where((t) => t.id.equals(id)))
        .write(TaskTableCompanion(
      isDone: Value(newValue),
    )
    );
  }

  Future<int> updateTask(int id, Task data) async {
    return (update(taskTable)..where((t) => t.id.equals(id)))
        .write(TaskTableCompanion(
        title: Value(data.title),
        note: Value(data.note),
        reminder: Value(data.reminder)
    )
    );
  }

  Future<int> deleteTask(int id) async {
    await Future.delayed(const Duration(seconds: 3));

    return (delete(taskTable)..where((t) => t.id.equals(id))).go();
  }
}