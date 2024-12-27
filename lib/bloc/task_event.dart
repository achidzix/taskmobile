part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTasks extends TaskEvent {
  final Task task;

  const AddTasks(this.task);

  @override
  List<Object> get props => [task];
}

class SearchTask extends TaskEvent {
  final Task task;

  const SearchTask(this.task);

  @override
  List<Object> get props => [task];
}

class RemoveTasks extends TaskEvent {
  final Task task;

  const RemoveTasks(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTasks extends TaskEvent {
  final Task task;

  const UpdateTasks(this.task);

  @override
  List<Object> get props => [task];
}
