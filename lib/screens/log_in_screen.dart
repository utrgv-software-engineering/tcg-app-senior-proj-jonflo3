import 'package:flutter/material.dart';
import 'package:tcg_app_sp/SQLite/sqlite.dart';
import 'package:tcg_app_sp/models/userinfo.dart';
import 'package:tcg_app_sp/screens/collection_screen.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/screens/reset_password_screen.dart';
// import 'package:tcg_app_sp/screens/sign_up_screen.dart';
import 'package:tcg_app_sp/screens/sign_up_screen.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  _LogInScreen createState() => _LogInScreen();

}

class _LogInScreen extends State<LogInScreen>{
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;
  final formKey = GlobalKey<FormState>();
  final db = DataBaseHelper();

  Future<void> login() async {
    var response = await db.login(Users(usrName: usernameController.text, usrPassword: passwordController.text));
    if(response == true){
      if(!mounted) return;
      Collection collect = Collection(cardIds: [], username: usernameController.text);
      await collect.fetchUserData();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => CollectionScreen(collect),
      ),);
    } else {
      if(!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context){ 
          return AlertDialog(
          title: const Text("Error"),
          content: const Text("Incorrect username or password"),
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
          children: [
            Center(
              child: Column(children: [
                const Text("Log In",
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
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off)),
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
                SizedBox(
                  width: 240.0,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Log in",
                      style: TextStyle(
                      color: Color(0xFF404040),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    )),
                    onPressed: () {
                      setState(() {
                        if(usernameController.text.isEmpty || passwordController.text.isEmpty){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){ 
                                return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Please enter a username and password"),
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
                        } else{
                            login();
                        }
                      });
                    },
                )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const ResetPasswordScreen(),
                        ),);
                      },
                      child: const Text("Forgot password?",
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () { 
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                      },
                      child: const Text("Create account",
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
          ]))
      ]))
    );
  }
}