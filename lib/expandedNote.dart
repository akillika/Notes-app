import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/homepage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ExpandedNote extends StatefulWidget {
  const ExpandedNote(
      {Key? key,
      required this.title,
      required this.desc,
      required this.userID,
      required this.docID,
      // required this.time,
      required this.date})
      : super(key: key);

  final String title;
  final String desc;
  final String userID;
  final String docID;
  // final String time;
  final String date;

  @override
  _ExpandedNoteState createState() => _ExpandedNoteState();
}

class _ExpandedNoteState extends State<ExpandedNote> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // String? _selectedTime;
  late DateTime dt;
  // late TimeOfDay _savedTime;
  late DateTime selectedDate;

  // Future<void> _showTimePicker() async {
  //   final TimeOfDay? result =
  //       await showTimePicker(context: context, initialTime: _savedTime);
  //   if (result != null) {
  //     setState(() {
  //       _savedTime = result;
  //     });
  //   }
  // }

  // _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: dt, // Refer step 1
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime(2025),
  //   );
  //   if (picked != null && picked != dt)
  //     setState(() {
  //       dt = picked;
  //     });
  // }

  Future<void> updateUser(
      String title, String description, String docID, String date) {
    return users
        .doc(widget.userID)
        .collection(widget.userID)
        .doc(docID)
        .update(
          {
            'title': title,
            'description': description,
            'datetime': date,
            // 'time': time
          },
        )
        .then((value) => print("Note Updated"))
        .catchError((error) => print("Failed to update note: $error"));
  }

  Future<void> deleteNote(String docID) {
    return users
        .doc(widget.userID)
        .collection(widget.userID)
        .doc(docID)
        .delete()
        .then((value) => print("Note Updated"))
        .catchError((error) => print("Failed to update note: $error"));
  }

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // docID = widget.docID;
    // _savedTime = TimeOfDay(
    //     hour: int.parse(widget.time.split(":")[0]),
    //     minute: int.parse(widget.time.split(":")[1].split(" ")[0]));
    // dt = DateTime.parse(widget.date);
    selectedDate = DateTime.parse(widget.date);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
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
                    padding: EdgeInsets.all(15.0),
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
              TextButton(
                  onPressed: () {
                    // _selectDate(context);
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true, onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      print('confirm $date');
                      setState(() {
                        selectedDate = date;
                      });
                    }, currentTime: DateTime.now());
                  },
                  child: Text(
                    "Choose a date: ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              Text(
                selectedDate.toString().substring(0, 16) + " IST",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     TextButton(
              //         onPressed: () {
              //           _showTimePicker();
              //         },
              //         child: Text(
              //           "Choose a time: ",
              //           style: TextStyle(
              //               fontSize: 20, fontWeight: FontWeight.bold),
              //         )),
              //     Text(
              //       _savedTime.format(context),
              //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  updateUser(titleController.text, descController.text,
                      widget.docID, selectedDate.toString());
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
                      "Update note",
                      style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  deleteNote(widget.docID);
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
                      color: Colors.red,
                      // border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: Center(
                    child: Text(
                      "Delete note",
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
