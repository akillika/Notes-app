import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/homepage.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (await FirebaseAuth.instance.currentUser != null) {
    var currentUser = FirebaseAuth.instance.currentUser;

    runApp(MyApp1(currentUser!.uid.toString()));
  } else {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
    );
  }
}

class MyApp1 extends StatelessWidget {
  MyApp1(this.uid);
  final String uid;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(
        userID: uid,
      ),
    );
  }
}
