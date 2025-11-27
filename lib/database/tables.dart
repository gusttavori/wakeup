import 'package:drift/drift.dart';

import 'converters/string_list_converter.dart';

class AlarmTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  TextColumn get repeat => text().map(const StringListConverter())();
  TextColumn get time => text()();
  BoolColumn get isActive => boolean()();
  TextColumn get sound => text()();
  BoolColumn get snooze => boolean()();
}

class TaskTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get note => text()();
  DateTimeColumn get reminder => dateTime().nullable()();
  BoolColumn get isDone => boolean()();
}