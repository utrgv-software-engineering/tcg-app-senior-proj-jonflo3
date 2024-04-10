import 'package:flutter/material.dart';
import 'package:tcg_app_sp/SQLite/sqlite.dart';
import 'package:tcg_app_sp/models/userinfo.dart';
// import 'package:tcg_app_sp/models/userinfo.dart';
import 'package:tcg_app_sp/screens/log_in_screen.dart';
// import 'package:tcg_app_sp/screens/collection_screen.dart';
// import 'package:tcg_app_sp/models/collection.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreen createState() => _SignUpScreen();

}

class _SignUpScreen extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isVisible = false;
  bool isTaken = false;
  final formKey = GlobalKey<FormState>();
  final db = DataBaseHelper();

  Future<void> checkUsername() async {
    var response = await db.getUser(usernameController.text);
    setState(() {
      isTaken = response ? true : false;
    });
    }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF404040)),
        child: Column(
          key: formKey,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Center(
            child: Column(
              children: [
                const Text("Sign Up",
                  style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  decorationColor: Color(0xFFFFFFFF),
                  ),
                ),
                const SizedBox(height: 10,),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: TextField(
                    controller: passwordController,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off)),
                      prefixIcon: const Icon(Icons.lock),
                      labelText: 'Password',
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
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off)),
                      prefixIcon: const Icon(Icons.lock),
                      labelText: 'Confirm Password',
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
                const SizedBox(height: 15),
                SizedBox(
                  width: 240.0,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))
                    ),
                    child: const Text("Create Account",
                      style: TextStyle(
                        color: Color(0xFF404040),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                    )),
                    onPressed: () async {
                      await checkUsername();
                      setState(() {
                        if(isTaken){
                          showDialog(
                            context: context,
                            builder: (BuildContext context){ 
                              return AlertDialog(
                              title: const Text("Error"),
                              content: const Text("Username is already taken"),
                              actions: <Widget>[
                                TextButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, 
                                  child: const Text("OK")),
                                ],
                              );
                            },
                          );
                        }
                        else if(usernameController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty){
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
                                  child: const Text("OK")),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        else if(passwordController.text != confirmPasswordController.text){
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
                        else{
                          final db = DataBaseHelper();
                          db.createUser(Users(usrName: usernameController.text, usrPassword: passwordController.text))
                          .whenComplete(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context){ 
                                return AlertDialog(
                                title: const Text("Sign Up"),
                                content: const Text("New account created!"),
                                actions: <Widget>[
                                  TextButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, 
                                    child: const Text("OK")),
                                  ],
                                );
                              },
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInScreen()));
                          });
                        }
                      });
                    },
                  )
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                    ),),
                    GestureDetector(
                      onTap: () { 
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInScreen()));
                          },
                      child: const Text("Log in",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                          onTap: () async {
                            setState(() {
                              usernameController.text = '';
                              passwordController.text = '';
                              confirmPasswordController.text = '';
                            });
                          },
                          child: const Text("Clear",
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                  ],
                ),
              ],)
          )
        ],)
      ));

  }
}