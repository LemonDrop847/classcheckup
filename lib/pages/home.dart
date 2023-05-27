import 'package:classcheckup/components/subcard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final String uid;
  const HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Classes'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                var userData = snapshot.data!.data() as Map<String, dynamic>?;
                if (userData != null && userData.containsKey('subjects')) {
                  List<dynamic> subjectsData =
                      userData['subjects'] as List<dynamic>;
                  return ListView.builder(
                    itemCount: subjectsData.length,
                    itemBuilder: (context, index) {
                      var subject = subjectsData[index];
                      String subname = subject['subname'] as String;
                      subname = subname.toUpperCase();
                      String id = uid;
                      double attend = subject['curr'] == 0
                          ? 0
                          : subject['curr'] / subject['total'] * 100;
                      return SubCard(
                        subname: subname,
                        id: id,
                        attend: attend,
                      );
                    },
                  );
                }
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
