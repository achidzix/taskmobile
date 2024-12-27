import 'package:flutter/material.dart';
import 'package:taskmobile/screens/HomeScreen.dart';
import 'package:taskmobile/services/DomainService.dart';
import 'package:taskmobile/widgets/MyTextInput.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String Errormsg = '';
  final domain = DomainService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
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
                height: 30,
              ),
              MyTextInput(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: true,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$Errormsg',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
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
                    child: Text("Sign Up"),
                  ),
                  onPressed: () async {
                    if (usernameController.text.length <= 5) {
                      print("mismatch");
                      setState(() {
                        Errormsg = "Username must be at least 5 characters";
                      });
                    }
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      print("mismatch");
                      setState(() {
                        Errormsg = "Password mismatch";
                      });
                    }
                    if (passwordController.text ==
                            confirmPasswordController.text &&
                        passwordController.text.length >= 6) {
                      final res = await domain.register(
                          usernameController.text, passwordController.text);
                      print("registering");
                      if (res != null) {
                        print(res.statusCode);
                        if (res.statusCode != 201) {
                          print("setting error message");
                          setState(() {
                            Errormsg = 'Something went wrong';
                          });
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                      } else {
                        setState(() {
                          Errormsg = 'Something went wrong';
                        });
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an Account?",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Sign In",
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
