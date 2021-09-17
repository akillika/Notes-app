import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:notes_app/homepage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
  late FlutterLocalNotificationsPlugin fltrNotification;
  late int notificationID;
  // String? _selectedTime;
  late int id = 0;
  var now = DateTime.now();

  incrementNotificiationID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notificationID = (prefs.getInt('counter') ?? 0) + 1;
    print('set $notificationID times.');
    await prefs.setInt('counter', notificationID);
    setState(() {
      id = notificationID;
      print(id);
    });
    return id;
  }

  Future _showNotification(DateTime date, int id) async {
    var androidDetails = new AndroidNotificationDetails(
        "Chanel ID", "Akil", "Hi I am Akil",
        importance: Importance.max);
    var iOSDetails = new IOSNotificationDetails();
    // var generalNotificationDetails =
    //     new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    // await fltrNotification.show(
    //     0, 'Hi', "this is a notification", generalNotificationDetails);

    var time = tz.TZDateTime.from(
      date,
      tz.local,
    );
    print("$id this is the ID for notification");

    fltrNotification.zonedSchedule(
        id,
        'scheduled title',
        'scheduled body',
        time,
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  // Future<void> _showTimePicker() async {
  //   final TimeOfDay? result =
  //       await showTimePicker(context: context, initialTime: TimeOfDay.now());
  //   if (result != null) {
  //     setState(() {
  //       _selectedTime = result.format(context);
  //     });
  //   }
  // }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate, // Refer step 1
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2025),
  //   );
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //     });
  // }

  Future<void> addUser(String title, String desc, String date) {
    print(widget.userID);
    // Call the user's CollectionReference to add a new user
    return users
        .doc(widget.userID)
        .collection(widget.userID)
        .add({'title': title, 'description': desc, 'datetime': date})
        .then((value) => print("Note Added"))
        .catchError((error) => print("Failed to add note: $error"));
  }

  // showTimeZone() async {
  //   final String currentTimeZone =
  //       await FlutterNativeTimezone.getLocalTimezone();
  //   print(currentTimeZone);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Asia/Kolkata"));

    var androidInitilize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = new IOSInitializationSettings();
    final InitializationSettings initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);

    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
              // Row(
              //   children: [
              //     TextButton(
              //         onPressed: () {
              //           _selectDate(context);
              //         },
              //         child: Text(
              //           "Choose a date: ",
              //           style: TextStyle(
              //               fontSize: 20, fontWeight: FontWeight.bold),
              //         )),
              //     Text(
              //       "${selectedDate.toLocal()}".split(' ')[0],
              //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              TextButton(
                  onPressed: () {
                    // _showTimePicker();
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
                    "Select a Date and time",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              Text(
                selectedDate.toString().substring(0, 16) + " IST",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  await incrementNotificiationID();
                  _showNotification(selectedDate, notificationID);
                  if (selectedDate.compareTo(now) < 0) {
                    final snackBar = SnackBar(
                      content: const Text('Date is chosen in past!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    addUser(titleController.text, descController.text,
                        selectedDate.toString());
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

  Future notificationSelected(String? payload) async {}
}
