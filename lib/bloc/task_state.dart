part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskInitial extends TaskState {}

final class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

final class TaskSearch extends TaskState {
  final List<Task> tasks;

  const TaskSearch({required this.tasks});

  @override
  List<Object> get props => [tasks];
}
