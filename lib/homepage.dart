import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app/addNote.dart';
import 'package:notes_app/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
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
                _signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Icon(
                Icons.exit_to_app_outlined,
                color: Colors.green,
              ),
            ),
          )
        ],
        backgroundColor: Colors.white,
        title: Text(
          "All notes",
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(
                  data['title'],
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(data['description']),
              );
            }).toList(),
          );
        },
      ),
      // body: Container(
      //   child: StaggeredGridView.countBuilder(
      //     crossAxisCount: 4,
      //     itemCount: 8,
      //     itemBuilder: (BuildContext context, int index) => new Container(
      //         color: Colors.green,
      //         child: new Center(
      //           child: Padding(
      //             padding: const EdgeInsets.all(10.0),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 new Text(
      //                   'Hello world to the maximum',
      //                   style: TextStyle(
      //                       fontWeight: FontWeight.bold, fontSize: 20),
      //                 ),
      //                 SizedBox(
      //                   height: 10,
      //                 ),
      //                 new Text('This is a test note'),
      //               ],
      //             ),
      //           ),
      //         )),
      //     staggeredTileBuilder: (int index) =>
      //         new StaggeredTile.count(2, index.isEven ? 2 : 1),
      //     mainAxisSpacing: 4.0,
      //     crossAxisSpacing: 4.0,
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // addUser("hello", "this is a description");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNote()));
        },
      ),
    );
  }
}
