import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmobile/screens/HomeScreen.dart';
import 'package:taskmobile/screens/auth/RegisterScreen.dart';
import 'package:taskmobile/services/DomainService.dart';
import 'package:taskmobile/widgets/MyTextInput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String error = '';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final ipController = TextEditingController();
  final domain = DomainService();

  @override
  Widget build(BuildContext context) {
    void setting() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> data = [usernameController.text, passwordController.text];
      prefs.setStringList('user', data);
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      height: 30,
                      color: Colors.purple,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: Text("Enter Remote Server IP"),
                                  content: TextField(
                                    controller: ipController,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400),
                                      ),
                                      fillColor: Colors.grey.shade200,
                                      filled: true,
                                      hintText: "192.168.10.20",
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    MaterialButton(
                                      color: Colors.purple,
                                      textColor: Colors.grey[50],
                                      child: Text("Save"),
                                      onPressed: () async {
                                        if (ipController.text.isNotEmpty) {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          await prefs.setString(
                                              'serverIP', ipController.text);
                                        }
                                      },
                                    ),
                                  ]);
                            });
                      },
                      child: Icon(
                        Icons.wifi_tethering_sharp, //construction_sharp,
                        size: 30,
                        color: Colors.grey[50],
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/task-logo.png',
                height: 80,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Welcome Back ",
              ),
              SizedBox(
                height: 30,
              ),
              MyTextInput(
                controller: usernameController,
                hintText: "Username",
                obscureText: false,
              ),
              SizedBox(
                height: 30,
              ),
              MyTextInput(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
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
                    child: Text("Sign In"),
                  ),
                  onPressed: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final str = await prefs.getStringList('user');

                    if (str != null) {
                      if (str[0] == usernameController.text &&
                          str[1] == passwordController.text) {
                        final snac = SnackBar(
                          content:
                              Text("Welcome back! ${usernameController.text}"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snac);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      } else {
                        setState(() {
                          error = 'Unauthorized access';
                          print(error);
                        });
                      }
                    } else {
                      final res = await domain.getToken(
                          usernameController.text, passwordController.text);
                      if (res != null) {
                        if (res.statusCode == 401) {
                          print("setting error message");
                          setState(() {
                            error = 'Unauthorized access';
                            print(error);
                          });
                        } else {
                          setting();
                          final snac = SnackBar(
                            content: Text(
                                "Welcome back! ${usernameController.text}"),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snac);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                      } else {
                        //something went wrong
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an Account?",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
