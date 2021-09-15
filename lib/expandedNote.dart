import 'package:flutter/material.dart';

class ExpandedNote extends StatefulWidget {
  const ExpandedNote({Key? key, required this.title, required this.desc})
      : super(key: key);

  final String title;
  final String desc;

  @override
  _ExpandedNoteState createState() => _ExpandedNoteState();
}

class _ExpandedNoteState extends State<ExpandedNote> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
              Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
