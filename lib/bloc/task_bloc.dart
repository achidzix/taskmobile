import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taskmobile/databases/database.dart';
import 'package:taskmobile/models/tasks.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      List<Task> data = await AppDatabase.instance.readAllTask();

      emit(TaskLoaded(tasks: data));
    });
    on<AddTasks>((event, emit) {
      if (state is TaskLoaded) {
        final state = this.state as TaskLoaded;
        // db.createTask(event.task);
        emit(
          TaskLoaded(
            tasks: List.from(state.tasks)..add(event.task),
          ),
        );
      }
    });
    on<RemoveTasks>((event, emit) async {
      if (state is TaskLoaded) {
        final state = this.state as TaskLoaded;
        int id = await AppDatabase.instance.deleteTask(event.task);

        emit(
          TaskLoaded(
            tasks: List.from(state.tasks)..remove(event.task),
          ),
        );
      }
    });
    on<UpdateTasks>((event, emit) {
      if (state is TaskLoaded) {
        final state = this.state as TaskLoaded;
        List<Task> remove = List.from(
            state.tasks.where((element) => element.id == event.task.id));
        emit(
          TaskLoaded(
            tasks: List.from(state.tasks)
              ..remove(remove[0])
              ..add(event.task),
          ),
        );
      }
    });
    on<SearchTask>((event, emit) async {
      final state = this.state as TaskLoaded;
      List<Task> filtered = List.from(state.tasks
          .where((element) => element.title.contains(event.task.title)));

      if (event.task.title == '') {
        List<Task> data = await AppDatabase.instance.readAllTask();
        emit(TaskLoaded(tasks: data));
      } else {
        emit(TaskLoaded(tasks: filtered));
      }
    });
  }
}
