import 'package:flutter/material.dart';
import 'package:tcg_app_sp/screens/log_in_screen.dart';
import 'package:tcg_app_sp/screens/sign_up_screen.dart';

class LoginOrRegisterPage extends StatefulWidget{
  const LoginOrRegisterPage({super.key});
  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context){
    if(showLoginPage){
      return LogInScreen(onTap: togglePages);
    }
    else{
      return SignUpScreen(onTap: togglePages);
    }
  }
}