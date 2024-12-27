import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmobile/bloc/task_bloc.dart';
import 'package:taskmobile/databases/database.dart';
import 'package:taskmobile/models/TaskLogger.dart';
import 'package:taskmobile/models/tasks.dart';
import 'package:taskmobile/screens/HomeScreen.dart';
import 'package:taskmobile/widgets/MyTextInput.dart';

class EditTaskScreen extends StatefulWidget {
  final Task? tasky;
  const EditTaskScreen({Key? key, this.tasky}) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  DateTime dt = DateTime.now();
  final titleController1 = TextEditingController();
  final descriptionController1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(
      text: widget.tasky == null ? "" : widget.tasky!.title,
    );
    final descriptionController = TextEditingController(
      text: widget.tasky == null ? "" : widget.tasky!.description,
    );
    TimeOfDay d = widget.tasky == null
        ? TimeOfDay.now()
        : TimeOfDay(
            hour: widget.tasky!.deadline.hour,
            minute: widget.tasky!.deadline.minute,
          );
    DateTime dateTime = widget.tasky == null
        ? DateTime.now()
        : DateTime(
            widget.tasky!.deadline.year,
            widget.tasky!.deadline.month,
            widget.tasky!.deadline.day,
            widget.tasky!.deadline.hour,
            widget.tasky!.deadline.minute,
          );

    //DateTime finalDate = DateTime.now();

    // void _showTimePicker() {
    //   showTimePicker(
    //     context: context,
    //     initialTime: TimeOfDay.now(),
    //   ).then((onValue) {
    //     setState(() {
    //       d = onValue!;
    //     });
    //   });
    // }

    Future<DateTime?> pickDate() => showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          initialDate: dateTime,
          lastDate: DateTime(2100),
        );
    Future<TimeOfDay?> pickTime() => showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: d.hour, minute: d.minute),
        );

    Future pickDateTime() async {
      DateTime? date = await pickDate();
      if (date == null) return;
      TimeOfDay? time = await pickTime();
      if (time == null) return;

      setState(() {
        dateTime = date;
        d = time;
        //TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
        dt = DateTime(
            dateTime.year, dateTime.month, dateTime.day, d.hour, d.minute);
        //titleController = titleController.text;
        //finalDate = TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
      });
    }

    Future saveTask() async {
      final task = Task(
        title:
            widget.tasky == null ? titleController1.text : titleController.text,
        description: widget.tasky == null
            ? descriptionController1.text
            : descriptionController.text,
        deadline: dt,
        is_synced: false,
      );
      //create mode
      if (widget.tasky == null) {
        Task d = await AppDatabase.instance.createTask(task);
        if (d != null) {
          TaskLogger data = TaskLogger(
              tid: d.id!,
              title: task.title,
              description: task.description,
              deadline: task.deadline,
              last_updated: DateTime.now(),
              is_synced: false,
              is_deleted: false,
              tuid: null);
          print('create');
          final snac = SnackBar(
            content: Text("Task Added Succeffully"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snac);
          await AppDatabase.instance.createTaskLogger(data);
          context.read<TaskBloc>().add(AddTasks(d));
        }
      } else {
        //edit mode
        final taskL =
            await AppDatabase.instance.readTaskLogger(widget.tasky!.id!);
        //is not synced

        TaskLogger data = TaskLogger(
            tid: taskL.first.tid,
            title: task.title,
            description: task.description,
            deadline: task.deadline,
            last_updated: DateTime.now(),
            is_synced: false,
            is_deleted: false,
            tuid: taskL.first.tuid);
        await AppDatabase.instance
            .updateTaskLogger(data.copyWith(id: widget.tasky!.id!));

        context
            .read<TaskBloc>()
            .add(UpdateTasks(task.copyWith(id: widget.tasky!.id!)));

        final snac = SnackBar(
          content: Text("Task Updated Succeffully"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snac);
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          widget.tasky == null ? "Create Task" : "Edit Task",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 5,
                    ),
                    child: Text(
                      "Title",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              MyTextInput(
                controller:
                    widget.tasky != null ? titleController : titleController1,
                hintText: "Title",
                obscureText: false,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 5,
                    ),
                    child: Text(
                      "Description",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              MyTextInput(
                controller: widget.tasky != null
                    ? descriptionController
                    : descriptionController1,
                hintText: "Description",
                obscureText: false,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 5,
                    ),
                    child: Text(
                      "Deadline",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: MaterialButton(
                  height: 50,
                  onPressed: () async {
                    await pickDateTime();
                  },
                  color: Colors.purple,
                  textColor: Colors.grey[50],
                  child: Center(
                    child: Text(
                      "${dt.year}/${dt.month}/${dt.day} ${dt.hour}:${dt.minute}",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: MaterialButton(
                  height: 50,
                  textColor: Colors.grey[300],
                  color: Colors.black,
                  child: Center(
                    child: Text(widget.tasky == null ? "Save" : "Update"),
                  ),
                  onPressed: () async {
                    saveTask();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
