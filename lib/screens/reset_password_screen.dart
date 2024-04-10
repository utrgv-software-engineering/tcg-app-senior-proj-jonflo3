import 'package:flutter/material.dart';
import 'package:tcg_app_sp/SQLite/sqlite.dart';
import 'package:tcg_app_sp/screens/log_in_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreen createState() => _ResetPasswordScreen();

}

class _ResetPasswordScreen extends State<ResetPasswordScreen> {
    TextEditingController usernameController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmNewPasswordController = TextEditingController();
    bool isVisible = false;
    final db = DataBaseHelper();

  Future<void> resetPassword() async {
      var response = await db.getUser(usernameController.text);
      if(response == true){
        await db.updateUser(usernameController.text, newPasswordController.text).whenComplete(() {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInScreen()));
        });
      } else {
        if(!mounted) return;
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
                child: const Text("OK")),
              ],
            );
          },
        );
      }
    }

  @override

  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

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
                const SizedBox(height: 10),
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
                    controller: newPasswordController,
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
                    controller: confirmNewPasswordController,
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
                      labelText: 'Confirm New password',
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
                        if(usernameController.text.isEmpty){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){ 
                                return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Please enter a username"),
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
                        else if(newPasswordController.text.isEmpty || confirmNewPasswordController.text.isEmpty){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){ 
                                return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Please enter a password"),
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
                        else if(newPasswordController.text != confirmNewPasswordController.text){
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
                        } else{
                          resetPassword();
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