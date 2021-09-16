import 'package:flutter/material.dart';
import 'package:notes_app/auth.dart';
import 'package:notes_app/homepage.dart';
import 'package:notes_app/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lets get started!",
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
            // SizedBox(
            //   height: 20,
            // ),
            // TextField(
            //   decoration: const InputDecoration(
            //       border: OutlineInputBorder(), hintText: 'Confirm password'),
            // ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                AuthenticationHelper()
                    .signUp(
                        email: emailController.text,
                        password: passController.text)
                    .then((result) {
                  if (result == null) {
                    var currentUser = FirebaseAuth.instance.currentUser;

                    if (currentUser != null) {
                      print(currentUser.uid);
                    }
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  userID: currentUser!.uid.toString(),
                                )));
                  } else {
                    // ignore: deprecated_member_use
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
                    "Sign Up",
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
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Have an account already?"),
                  Text(
                    " Sign In",
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
