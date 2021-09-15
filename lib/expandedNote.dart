import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/homepage.dart';

class ExpandedNote extends StatefulWidget {
  const ExpandedNote(
      {Key? key,
      required this.title,
      required this.desc,
      required this.userID,
      required this.docID})
      : super(key: key);

  final String title;
  final String desc;
  final String userID;
  final String docID;

  @override
  _ExpandedNoteState createState() => _ExpandedNoteState();
}

class _ExpandedNoteState extends State<ExpandedNote> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  // late String docID;

  Future<void> updateUser(String title, String description, String docID) {
    return users
        .doc(widget.userID)
        .collection(widget.userID)
        .doc(docID)
        .update({'title': title, 'description': description})
        .then((value) => print("Note Updated"))
        .catchError((error) => print("Failed to update note: $error"));
  }

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // docID = widget.docID;
    titleController.text = widget.title;
    descController.text = widget.desc;
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.title;
    descController.text = widget.desc;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                      maxLines: 20,
                      decoration:
                          InputDecoration.collapsed(hintText: "Description"),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  updateUser(
                      titleController.text, descController.text, widget.docID);
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => HomePage(
                        userID: widget.userID,
                      ),
                    ),
                    (route) =>
                        false, //if you want to disable back feature set to false
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
                      "Update",
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
