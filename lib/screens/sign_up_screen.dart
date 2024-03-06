import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/userinfo.dart';
import 'package:tcg_app_sp/screens/log_in_screen.dart';
import 'package:tcg_app_sp/screens/collection_screen.dart';
import 'package:tcg_app_sp/models/collection.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreen createState() => _SignUpScreen();

}

class _SignUpScreen extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
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
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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
                    obscureText: true,
                    decoration: InputDecoration(
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
                      setState(() {
                          if(emailController.text == '' || usernameController.text == '' || passwordController.text == '' || confirmPasswordController.text == ''){
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
                          for(User user in users){
                            if(user.email != emailController.text && user.username != usernameController.text && passwordController.text == confirmPasswordController.text){
                              Collection collect = Collection(cardIds: []);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => CollectionScreen(collect),
                              ),);
                              break;
                            }
                            else{
                              if(user.email == emailController.text){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context){ 
                                    return AlertDialog(
                                    title: const Text("Error"),
                                    content: const Text("Email is already used"),
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
                              else if(user.username == usernameController.text){
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
                                        child: const Text("Ok")),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }
                              else{
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
                            }
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
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const LogInScreen(),
                        ),);
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
                              emailController.text = '';
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