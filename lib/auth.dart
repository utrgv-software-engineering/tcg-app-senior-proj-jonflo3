import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcg_app_sp/models/collection.dart';
import 'package:tcg_app_sp/screens/collection_screen.dart';
// import 'package:tcg_app_sp/screens/log_in_screen.dart';
import 'package:tcg_app_sp/screens/toggle_login_register.dart';

class Auth extends StatelessWidget{
  const Auth({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            Collection collect = Collection(cardIds: []);
            return CollectionScreen(collect);
          }
          else{
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}