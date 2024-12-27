import 'package:equatable/equatable.dart';

final String tableName2 = "tasksLogger";

class TaskLoggerFields {
  static final List<String> values = [
    idField,
    tidField,
    titleField,
    descriptionField,
    deadlineField,
    is_syncedField,
    is_deletedField,
    tuidField
  ];
  static final String idField = "_id";
  static final String tidField = "tid";
  static final String titleField = "title";
  static final String descriptionField = "description";
  static final String deadlineField = "deadline";
  static final String last_updatedField = "last_updated";
  static final String is_syncedField = "is_synced";
  static final String is_deletedField = "is_deleted";
  static final String tuidField = "tuid";
}

class TaskLogger extends Equatable {
  int? id;
  int tid;
  String title;
  String description;
  DateTime deadline;
  DateTime last_updated;
  bool is_synced;
  bool is_deleted;
  String? tuid;

  TaskLogger({
    this.id,
    required this.tid,
    required this.title,
    required this.description,
    required this.deadline,
    required this.last_updated,
    required this.is_synced,
    required this.is_deleted,
    this.tuid,
  });

  static TaskLogger fromJson(Map<String, dynamic> json) => TaskLogger(
        id: json[TaskLoggerFields.idField] as int?,
        tid: json[TaskLoggerFields.tidField] as int,
        title: json[TaskLoggerFields.titleField] as String,
        description: json[TaskLoggerFields.descriptionField] as String,
        deadline:
            DateTime.parse(json[TaskLoggerFields.deadlineField] as String),
        last_updated:
            DateTime.parse(json[TaskLoggerFields.last_updatedField] as String),
        is_synced: json[TaskLoggerFields.is_syncedField] == 1,
        is_deleted: json[TaskLoggerFields.is_deletedField] == 1,
        tuid: json[TaskLoggerFields.tuidField] as String?,
      );

  Map<String, Object?> toJson() => {
        TaskLoggerFields.idField: id,
        TaskLoggerFields.tidField: tid,
        TaskLoggerFields.titleField: title,
        TaskLoggerFields.descriptionField: description,
        TaskLoggerFields.deadlineField: deadline.toIso8601String(),
        TaskLoggerFields.last_updatedField: last_updated.toIso8601String(),
        TaskLoggerFields.is_syncedField: is_synced ? 1 : 0,
        TaskLoggerFields.is_deletedField: is_deleted ? 1 : 0,
        TaskLoggerFields.tuidField: tuid,
      };

  TaskLogger copyWith({
    int? id,
    int? tid,
    String? title,
    String? description,
    DateTime? deadline,
    DateTime? last_updated,
    bool? is_synced,
    bool? is_deleted,
    String? tuid,
  }) =>
      TaskLogger(
        id: id ?? this.id,
        tid: tid ?? this.tid,
        title: title ?? this.title,
        description: description ?? this.description,
        deadline: deadline ?? this.deadline,
        last_updated: last_updated ?? this.last_updated,
        is_synced: is_synced ?? this.is_synced,
        is_deleted: is_deleted ?? this.is_deleted,
        tuid: tuid ?? this.tuid,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        tid,
        title,
        description,
        deadline,
        last_updated,
        is_synced,
        is_deleted,
        tuid
      ];
}
