import 'package:flutter/material.dart';
import 'package:tcg_app_sp/screens/log_in_screen.dart';
import 'package:tcg_app_sp/models/userinfo.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreen createState() => _ResetPasswordScreen();

}

class _ResetPasswordScreen extends State<ResetPasswordScreen> {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    List<User> users = [
    User('admin', 'admin@gmail.com', 'admin'),
    User('user1', 'user1@example.com', 'password1'),
    User('user2', 'user2@example.com', 'password2'),
    User('user3', 'user3@example.com', 'password3'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF404040),
        elevation: 0, // Remove elevation
        leading: IconButton(
          iconSize: 30,
          icon: const Icon(Icons.arrow_back),
          color: const Color(0xffd3d3d3),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF404040)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(children: [
                const Text("Reset Password",
                  style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  decorationColor: Color(0xFFFFFFFF),
                  ),
                ),
                const SizedBox(height: 10,),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                        contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 15),
                      ),
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New password',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Conform new password',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    ),
                  ),
                ),
                // const SizedBox(height: 10),
                // // ignore: sized_box_for_whitespace
                // Text(
                //   match ? "" : "Passwords do not match",
                //   style: const TextStyle(
                //     fontSize: 15,
                //     color: Colors.red,
                //   ),
                // ),
                // Text(
                //   empty ? "Please enter a username and new password" : "",
                //   style: const TextStyle(
                //     fontSize: 15,
                //     color: Colors.red,
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Text(
                //   exists ? "" : "Username does not exist",
                //   style: const TextStyle(
                //     fontSize: 15,
                //     color: Colors.red,
                //   ),
                // ),
                const SizedBox(height: 10),
                // ignore: sized_box_for_whitespace
                Container(
                  width: 240.0,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Reset password",
                      style: TextStyle(
                      color: Color(0xFF404040),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    )),
                    onPressed: () {
                      setState(() {
                        if(usernameController.text == '' || passwordController.text == '' || confirmPasswordController.text == ''){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){ 
                                return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Fields cannot be empty"),
                                actions: <Widget>[
                                  TextButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, 
                                    child: const Text("Ok")),
                                  ],
                                );
                              },
                            );
                          return;
                        }
                        if(passwordController.text != confirmPasswordController.text){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){ 
                                return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Passwords do not match"),
                                actions: <Widget>[
                                  TextButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, 
                                    child: const Text("Ok")),
                                  ],
                                );
                              },
                            );
                          return;
                        }
                        for(User user in users){
                          if(user.username == usernameController.text){
                            Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const LogInScreen(),
                            ),);
                            break;
                          }
                          else{
                            showDialog(
                              context: context,
                              builder: (BuildContext context){ 
                                return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Username does not exist"),
                                actions: <Widget>[
                                  TextButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, 
                                    child: const Text("Ok")),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                        }
                      });
                    },
                )),
                const SizedBox(height: 10),
          ]))
      ]))
    );
  }
}