import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/auth.dart';
import 'package:notes_app/homepage.dart';
import 'package:notes_app/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello there!",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Email ID'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: passController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Password'),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                AuthenticationHelper()
                    .signIn(
                        email: emailController.text,
                        password: passController.text)
                    .then((result) {
                  if (result == null) {
                    var currentUser = FirebaseAuth.instance.currentUser;

                    if (currentUser != null) {
                      print(currentUser.uid);
                    }
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => HomePage(
                          userID: currentUser!.uid.toString(),
                        ),
                      ),
                      (route) =>
                          false, //if you want to disable back feature set to false
                    );
                  } else {
                    // print(result);
                    final snackBar = SnackBar(content: Text(result));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.green,
                    // border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            // SignInButton(
            //   Buttons.Google,
            //   onPressed: () {},
            // )
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont have an account?"),
                  Text(
                    " Sign Up",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
