import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../index.dart';

class SetupUser extends StatefulWidget {
  final String uid;
  const SetupUser({Key? key, required this.uid}) : super(key: key);

  @override
  State<SetupUser> createState() => _SetupUserState();
}

class _SetupUserState extends State<SetupUser> {
  List<String> subjects = [];
  TextEditingController subjectController = TextEditingController();

  void addSubject() {
    String newSubject = subjectController.text.toUpperCase();
    if (newSubject.isNotEmpty) {
      setState(() {
        subjects.add(newSubject);
        subjectController.clear();
      });
    }
  }

  void removeSubject(String subject) {
    setState(() {
      subjects.remove(subject);
    });
  }

  void submitSubjects() {
    if (subjects.isNotEmpty) {
      String userId = widget.uid;

      List<Map<String, dynamic>> subjectsData = subjects.map((subject) {
        return {
          'subname': subject,
          'curr': 0,
          'total': 0,
        };
      }).toList();

      FirebaseFirestore.instance.collection('subdata').doc(userId).set({
        'subjects': subjectsData,
      }).then((value) {
        print('Subjects submitted successfully!');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => IndexPage(
                      uid: widget.uid,
                    )),
            (Route<dynamic> route) => false);
      }).catchError((error) {
        print('Error submitting subjects: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup User'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      hintText: 'Enter subject name',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addSubject,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return ListTile(
                  title: Text(subject),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => removeSubject(subject),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: submitSubjects,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
