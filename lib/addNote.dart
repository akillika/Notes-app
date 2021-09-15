import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/homepage.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String title, String desc) {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'title': title,
          'description': desc,
        })
        .then((value) => print("Note Added"))
        .catchError((error) => print("Failed to add note: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,

        backgroundColor: Colors.white,
        title: Text(
          "Add notes",
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: titleController,
                      maxLines: 2,
                      decoration: InputDecoration.collapsed(hintText: "Title"),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: descController,
                      maxLines: 15,
                      decoration:
                          InputDecoration.collapsed(hintText: "Description"),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  addUser(titleController.text, descController.text);
                  final snackBar =
                      SnackBar(content: Text("Note added sucessfully"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => HomePage(),
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      // border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: Center(
                    child: Text(
                      "Add note",
                      style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
