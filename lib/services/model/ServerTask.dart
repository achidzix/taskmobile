import 'package:equatable/equatable.dart';

final String tableName = "tasks";

class TaskFields {
  static final List<String> values = [
    idField,
    titleField,
    descriptionField,
    deadlineField,
    last_updatedField
  ];
  static final String idField = "id";
  static final String titleField = "title";
  static final String descriptionField = "description";
  static final String deadlineField = "deadline";
  static final String last_updatedField = "last_updated";
}

class TaskServer extends Equatable {
  String? id;
  String title;
  String description;
  DateTime deadline;
  DateTime? last_updated;

  TaskServer({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.last_updated,
  });

  static TaskServer fromJson(Map<String, dynamic> json) => TaskServer(
        id: json[TaskFields.idField] as String?,
        title: json[TaskFields.titleField] as String,
        description: json[TaskFields.descriptionField] as String,
        deadline: DateTime.parse(json[TaskFields.deadlineField] as String),
        last_updated:
            DateTime.parse(json[TaskFields.last_updatedField] as String),
      );

  Map<String, Object?> toJson() => {
        TaskFields.titleField: title,
        TaskFields.descriptionField: description,
        TaskFields.deadlineField: deadline.toIso8601String(),
      };

  TaskServer copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    DateTime? last_updated,
  }) =>
      TaskServer(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        deadline: deadline ?? this.deadline,
        last_updated: last_updated ?? this.last_updated,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, description, deadline, last_updated];
}
