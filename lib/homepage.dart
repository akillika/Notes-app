import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/addNote.dart';
import 'package:notes_app/expandedNote.dart';
import 'package:notes_app/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.userID}) : super(key: key);

  final String userID;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final String uid = widget.userID;
  late String uid;
  late String formattedDate;
  late Stream<QuerySnapshot> _usersStream;
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userID)
        .collection(widget.userID)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Logout"),
                    content: Text("Do you really want to logout?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            ("Cancel"),
                          )),
                      TextButton(
                          onPressed: () {
                            _signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: Text("Logout",
                              style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
              },
              child: Icon(
                Icons.exit_to_app_outlined,
                color: Colors.white,
              ),
            ),
          )
        ],
        backgroundColor: Colors.green,
        title: Text(
          "All tasks",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                formattedDate = data['date'].substring(0, 10);
                return GestureDetector(
                  onTap: () {
                    print(document.id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpandedNote(
                                date: data['date'].toString(),
                                time: data['time'].toString(),
                                docID: document.id,
                                userID: widget.userID,
                                title: data['title'].toString(),
                                desc: data['description'].toString())));
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['title'],
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      data['time'],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Text(
                              data['description'],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNote(
                        userID: widget.userID,
                      )));
        },
      ),
    );
  }
}
