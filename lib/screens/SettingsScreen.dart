import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmobile/Usecases/SyncingData.dart';
import 'package:taskmobile/services/DomainService.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isConnected = false;
  bool hasToken = false;
  bool isLoading = false;
  bool usCase1 = false;
  bool usCase2 = false;
  bool isCompleted = false;
  final domain = DomainService();
  final syncing = Syncingdata();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          "Settings",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                    "Sync to Remote",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  height: 50,
                  color: Colors.purple,
                  textColor: Colors.grey[50],
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final bool connection =
                        await InternetConnectionChecker.instance.hasConnection;
                    List<String>? saved = await prefs.getStringList('user');
                    final res = await domain.getToken(saved![0], saved[1]);

                    if (res != null && res.statusCode == 200) {
                      prefs.setString('token', res.data);
                      setState(() {
                        hasToken = true;
                      });
                    }

                    setState(() {
                      isConnected = connection;
                      isLoading = false;
                    });
                  },
                  child: Text(
                    "Connect",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Internet Conectivity: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      isConnected ? "Online" : "Offline",
                      style: TextStyle(
                        fontSize: 20,
                        color:
                            isConnected ? Colors.green[600] : Colors.red[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Server Status: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      hasToken ? "Connected" : "Not Connected",
                      style: TextStyle(
                        fontSize: 20,
                        color: hasToken ? Colors.green[600] : Colors.red[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  height: 50,
                  color: Colors.purple,
                  textColor: Colors.grey[50],
                  onPressed: () async {
                    if (isConnected && hasToken) {
                      setState(() {
                        isLoading = true;
                      });
                      final done = await syncing.usecase1();
                      print('Status 1 ================== ${done.toString()}');
                      final done2 = await syncing.usecase2();
                      print('Status 2 ================== ${done2.toString()}');
                      final done3 = await syncing.usecase3();
                      print('Status 3 ================== ${done3.toString()}');
                      setState(() {
                        isCompleted = true;
                        usCase1 = done;
                        usCase2 = done2;
                        isLoading = false;
                      });
                    }
                  },
                  child: Text(
                    "Sync",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Sync Status",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    !usCase1 && isCompleted ? 'Failed' : '',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    !usCase2 && isCompleted ? 'Failed' : '',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    isCompleted ? "100%" : '-',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
