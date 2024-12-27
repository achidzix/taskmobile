import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmobile/bloc/task_bloc.dart';
import 'package:taskmobile/databases/database.dart';
import 'package:taskmobile/models/TaskLogger.dart';
import 'package:taskmobile/models/tasks.dart';
import 'package:taskmobile/screens/EditTaskScreen.dart';
import 'package:taskmobile/screens/HomeScreen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Details",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskScreen(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              alignment: Alignment.center,
              width: 35,
              child: Icon(
                Icons.add,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple[200],
                borderRadius: BorderRadius.circular(12),
              ),
              height: 300,
              width: double.maxFinite,
              padding: EdgeInsets.only(
                top: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          task.description,
                          style: TextStyle(
                            color: Colors.grey[50],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${task.deadline}',
                          style: TextStyle(
                            color: Colors.grey[50],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskScreen(
                                tasky: task,
                              ),
                            ),
                          );
                        },
                        child: Text("Edit"),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
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
                                        print("read logger");
                                        print(taskL.first.toString());

                                        if (taskL.first.tuid! == null) {
                                          await AppDatabase.instance
                                              .deleteTaskLogger(taskL[0]);
                                        } else {
                                          TaskLogger data = TaskLogger(
                                              id: taskL.first.id,
                                              tid: taskL.first.tid,
                                              title: task.title,
                                              description: task.description,
                                              deadline: task.deadline,
                                              last_updated: DateTime.now(),
                                              is_synced: false,
                                              is_deleted: true,
                                              tuid: taskL.first.tuid);
                                          print('task screen');
                                          print(data.toString());
                                          await AppDatabase.instance
                                              .updateTaskLogger(data);
                                        }

                                        context
                                            .read<TaskBloc>()
                                            .add(RemoveTasks(task));
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(),
                                          ),
                                        );
                                        final snac = SnackBar(
                                          content:
                                              Text("Deleted Task Succeffully"),
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
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
