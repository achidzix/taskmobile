import 'package:equatable/equatable.dart';

final String tableName = "tasks";

class TaskFields {
  static final List<String> values = [
    idField,
    titleField,
    descriptionField,
    deadlineField,
    is_syncedField
  ];
  static final String idField = "_id";
  static final String titleField = "title";
  static final String descriptionField = "description";
  static final String deadlineField = "deadline";
  static final String is_syncedField = "is_synced";
}

// static final List<String> list = [
//   TaskFields.idField,
//   TaskFields.titleField,
//   TaskFields.descriptionField,
//   TaskFields.deadlineField,
//   TaskFields.is_syncedField,
// ];

class Task extends Equatable {
  int? id;
  String title;
  String description;
  DateTime deadline;
  bool is_synced;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.is_synced,
  });

  static Task fromJson(Map<String, dynamic> json) => Task(
        id: json[TaskFields.idField] as int?,
        title: json[TaskFields.titleField] as String,
        description: json[TaskFields.descriptionField] as String,
        deadline: DateTime.parse(json[TaskFields.deadlineField] as String),
        is_synced: json[TaskFields.is_syncedField] == 1,
      );

  Map<String, Object?> toJson() => {
        TaskFields.idField: id,
        TaskFields.titleField: title,
        TaskFields.descriptionField: description,
        TaskFields.deadlineField: deadline.toIso8601String(),
        TaskFields.is_syncedField: is_synced ? 1 : 0,
      };

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? deadline,
    bool? is_synced,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        deadline: deadline ?? this.deadline,
        is_synced: is_synced ?? this.is_synced,
      );

  // static final empty = Task(
  //   id: 1,
  //   title: '',
  //   description: '',
  //   deadline: DateTime.now(),
  //   is_synced: false, //0 flase and 1 true
  // );

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, description, deadline, is_synced];
}
