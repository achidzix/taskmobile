import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmobile/bloc/task_bloc.dart';
import 'package:taskmobile/databases/database.dart';
import 'package:taskmobile/models/TaskLogger.dart';
import 'package:taskmobile/models/tasks.dart';
import 'package:taskmobile/screens/TaskDetailScreen.dart';

class TaskList extends StatelessWidget {
  final Task task;

  const TaskList({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: task),
                      ),
                    )
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          task.description,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        Text("${task.deadline}"),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Delete Task"),
                          content: Text(
                              "Are you sure you want to delete this task?"),
                          actions: [
                            MaterialButton(
                              color: Colors.grey[300],
                              onPressed: () async {
                                final taskL = await AppDatabase.instance
                                    .readTaskLogger(task.id!);
                                //created and deleted before sync
                                if (taskL[0].tuid == null) {
                                  await AppDatabase.instance
                                      .deleteTaskLogger(taskL[0]);
                                } else {
                                  //safe delete
                                  TaskLogger data = TaskLogger(
                                      id: taskL.first.id,
                                      tid: task.id!,
                                      title: taskL.first.title,
                                      description: taskL.first.description,
                                      deadline: taskL.first.deadline,
                                      last_updated: DateTime.now(),
                                      is_synced: false,
                                      is_deleted: true,
                                      tuid: taskL.first.tuid);
                                  print("save delete");
                                  print(data.toString());
                                  await AppDatabase.instance
                                      .updateTaskLogger(data);
                                }
                                context.read<TaskBloc>().add(RemoveTasks(task));
                                Navigator.pop(context);

                                final snac = SnackBar(
                                  content: Text("Task Deleted Succeffully"),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snac);
                              },
                              child: Text("Yes"),
                            ),
                            MaterialButton(
                              color: Colors.black26,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        );
                      });
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.purple,
                  size: 24,
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
