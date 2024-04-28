import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tcg_app_sp/firebase_options.dart';
import 'package:tcg_app_sp/screens/log_in_screen.dart';
import 'package:tcg_app_sp/SQLite/sqlite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DataBaseHelper db = DataBaseHelper();
  await db.initDB();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const LogInScreen(),
    );
  }
}