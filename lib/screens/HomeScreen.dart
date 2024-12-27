import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmobile/bloc/task_bloc.dart';
import 'package:taskmobile/databases/database.dart';
import 'package:taskmobile/models/tasks.dart';
import 'package:taskmobile/screens/EditTaskScreen.dart';
import 'package:taskmobile/screens/SettingsScreen.dart';
import 'package:taskmobile/screens/auth/LoginScreen.dart';
import 'package:taskmobile/widgets/TaskList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isLoading = false;
  late List<Task> tasks;
  String search = "";

  @override
  void initState() {
    super.initState();
    refreshTasks();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    AppDatabase.instance.close();
    super.dispose();
  }

  Future refreshTasks() async {
    setState(() => isLoading = true);
    this.tasks = await AppDatabase.instance.readAllTask();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 1, vsync: this);

    void searchLogic(String value) {}

    List<Task> dataT = [
      Task(
          id: 11,
          title: "",
          description: "sefgdsh",
          deadline: DateTime.now(),
          is_synced: false),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          "Tasks",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: () async {
              //final d = await AppDatabase.instance.readAllTaskLoggers();
              //print(d.toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              alignment: Alignment.center,
              width: 35,
              child: Icon(
                Icons.settings,
                size: 24,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.center,
              width: 35,
              child: Icon(
                Icons.logout,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SearchBar(
                    hintText: "Search for Tasks",
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 15),
                    ),
                    onChanged: (value) => search,
                    onSubmitted: (data) {
                      dataT[0].title = data;
                      //print('${dataT[0].title}  received');
                      context.read<TaskBloc>().add(SearchTask(dataT[0]));
                    },
                    onTapOutside: (event) {
                      print("outside");
                    },
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TabBar(
                        controller: tabController,
                        labelPadding: const EdgeInsets.only(
                          //left: 5,
                          right: 50,
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.black,
                        tabs: [
                          Tab(text: "All"),
                          // Tab(text: "Active"),
                          // Tab(text: "Expired"),
                        ]),
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: Container(
                    // height: 300,
                    // width: double.maxFinite,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: TabBarView(controller: tabController, children: [
                      BlocBuilder<TaskBloc, TaskState>(
                        builder: (context, state) {
                          if (state is TaskInitial) {
                            return const CircularProgressIndicator(
                              color: Colors.blue,
                            );
                          }
                          if (state is TaskLoaded) {
                            return ListView.builder(
                                itemCount: state.tasks.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print(state.tasks.length);
                                  if (state.tasks.isEmpty) {
                                    print("empty");
                                    return Text(
                                      "No Tasks available",
                                      style: TextStyle(color: Colors.purple),
                                    );
                                  } else {
                                    return TaskList(
                                      task: state.tasks[index],
                                    );
                                  }
                                });
                          } else {
                            return const Text("Something went wrong");
                          }
                        },
                      ),
                      // Text("vv"),
                      // Text("data"),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: MaterialButton(
                    textColor: Colors.grey[50],
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.black,
                    height: 50,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTaskScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add Task",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Icon(Icons.add),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
    );
  }
}
