import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/homepage.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key, required this.userID}) : super(key: key);

  final String userID;

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? _selectedTime;
  var now = DateTime.now();

  Future<void> _showTimePicker() async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _selectedTime = result.format(context);
      });
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> addUser(String title, String desc, String date, String? time) {
    print(widget.userID);
    // Call the user's CollectionReference to add a new user
    return users
        .doc(widget.userID)
        .collection(widget.userID)
        .add({'title': title, 'description': desc, 'time': time, 'date': date})
        .then((value) => print("Note Added"))
        .catchError((error) => print("Failed to add note: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,

        backgroundColor: Colors.green,
        title: Text(
          "Add a task",
          style: TextStyle(color: Colors.white),
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
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Text(
                        "Choose a date: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 10,
              // ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        _showTimePicker();
                      },
                      child: Text(
                        "Choose a time: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                  Text(
                    _selectedTime != null
                        ? _selectedTime!
                        : 'No time selected!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (selectedDate.compareTo(now) < 0) {
                    final snackBar = SnackBar(
                      content: const Text('Date is chosen in past!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  if (_selectedTime == null) {
                    final snackBar = SnackBar(
                      content: const Text('Choose a time!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    addUser(titleController.text, descController.text,
                        selectedDate.toLocal().toString(), _selectedTime);
                    final snackBar =
                        SnackBar(content: Text("Note added sucessfully"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => HomePage(
                          userID: widget.userID,
                        ),
                      ),
                      (route) => false,
                    );
                  }
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
