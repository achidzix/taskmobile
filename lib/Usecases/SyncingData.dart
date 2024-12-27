import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmobile/databases/database.dart';
import 'package:taskmobile/models/TaskLogger.dart';
import 'package:taskmobile/models/tasks.dart';
import 'package:taskmobile/services/DomainService.dart';
import 'package:taskmobile/services/model/ServerTask.dart';

class Syncingdata {
  Syncingdata();

  TaskLogger updated(TaskLogger task, String tuid) {
    task.is_synced = true;
    task.tuid = tuid;
    task.last_updated = DateTime.now();
    return task;
  }

  TaskLogger updatedSmpl(TaskLogger task) {
    task.is_synced = true;
    task.last_updated = DateTime.now();
    return task;
  }

  Task toTask(TaskLogger data) {
    Task task = Task(
        title: data.title,
        description: data.description,
        deadline: data.deadline,
        is_synced: true);
    return task;
  }

  TaskServer toTaskServer(TaskLogger data) {
    TaskServer task = TaskServer(
        id: data.tuid,
        title: data.title,
        description: data.description,
        deadline: data.deadline);
    return task;
  }

  //local created tasks
  Future<bool> usecase1() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('token');
    final domain = DomainService();
    if (token == null) {
      return false;
    } else {
      List<TaskLogger> syncdata =
          await AppDatabase.instance.readTaskLoggerUsecase1();
      for (TaskLogger data in syncdata) {
        //insert to server
        final res = await domain.insertServerTask(toTaskServer(data), token);
        //check for response
        if (res != null) {
          final serverres = res.data!;
          print(res.data!['id']);
          //update task
          await AppDatabase.instance.updateTask(toTask(data));
          //update lasklogger
          await AppDatabase.instance
              .updateTaskLogger(updated(data, res.data!['id']));
        } else {
          return false;
        }
      }
      return true;
    }
  }

//locally updated tasks
//before updating fetch all server tasks
//for every map check which between server and local
//every local greater than remote > continue the logic
//server data > local update local(task and TaskList)
  Future<bool> usecase2() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('token');
    final domain = DomainService();
    if (token == null) {
      return false;
    } else {
      //final serverTask = await domain.getServerTask(token);
      List<TaskLogger> syncdata =
          await AppDatabase.instance.readTaskLoggerUsecase2();
      print("local test if test");
      for (TaskLogger data in syncdata) {
        //update to server
        final res = await domain.updateServerTask(toTaskServer(data), token);

        //check for response
        if (res != null && res.data != []) {
          final serverres = res.data!;
          print(res.data!['id']);
          //update task
          await AppDatabase.instance.updateTask(toTask(data));
          //update lasklogger
          await AppDatabase.instance.updateTaskLogger(updatedSmpl(data));
        } else {
          return false;
        }
      }
      return true;
    }
  }

  Future<bool> usecase3() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString('token');
    final domain = DomainService();
    if (token == null) {
      return false;
    } else {
      print("hastoken");
      List<TaskLogger> syncdata =
          await AppDatabase.instance.readTaskLoggerUsecase3();
      print(syncdata.toString());
      for (TaskLogger data in syncdata) {
        print("deleting server .... ");
        print(data.toString());
        final res = await domain.deleteServerTask(toTaskServer(data), token);

        //check for response
        if (res != null && res.data != []) {
          //update lasklogger
          await AppDatabase.instance.deleteTaskLogger(updatedSmpl(data));
        } else {
          return false;
        }
      }
      return true;
    }
  }
}




 //check if local date > server
        // print("local teat");
        // if (serverTask == null) {
        //   print("local not null");
        //   //not data
        // } else {
        //   final tempo = serverTask.where((ts) =>
        //       ts?.id! == data.tid &&
        //       ts!.last_updated!.isAfter(data.last_updated));
        //   //not after date
        //   if (tempo.isEmpty) {
        //     print("normal");
        //   } else {
        //     // server date is latest
        //     print("server latest");
        //   }
        // }