// =============================================
// 3. MODELOS DE DADOS (Mock)
// =============================================

class Alarm {
  final int? id;
  String time;
  String label;
  List<String> repeat;
  bool isActive;
  String sound;
  bool snooze;
  final bool? active;

  Alarm({
    this.id,
    required this.time,
    required this.label,
    required this.repeat,
    required this.isActive,
    required this.sound,
    required this.snooze,
    this.active,
  });

  Alarm copyWith({
    int? id,
    String? time,
    String? label,
    List<String>? repeat,
    bool? isActive,
    String? sound,
    bool? snooze,
  }) {
    return Alarm(
      id: id ?? this.id,
      time: time ?? this.time,
      label: label ?? this.label,
      repeat: repeat ?? this.repeat,
      isActive: isActive ?? this.isActive,
      sound: sound ?? this.sound,
      snooze: snooze ?? this.snooze,
    );
  }
}

class Task {
  final int? id;
  String title;
  String note;
  DateTime? reminder;
  bool isDone;
  final bool? done;

  Task({
    this.id,
    required this.title,
    required this.note,
    this.reminder,
    this.isDone = false,
    this.done
  });

  Task copyWith({
    int? id,
    String? title,
    String? note,
    DateTime? reminder,
    bool? isDone,

  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      reminder: reminder ?? this.reminder,
      isDone: isDone ?? this.isDone,
    );
  }
}

class StopwatchLap {
  final int id;
  final String time;
  StopwatchLap(this.id, this.time);
}
