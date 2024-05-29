import 'package:flutter/material.dart';
import 'package:pshgtask2/allqueries.dart';
import 'package:pshgtask2/dashboardscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pshgtask2/landingscreen.dart';
import 'package:pshgtask2/loginscreen.dart';
import 'package:pshgtask2/manageprofilescreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}