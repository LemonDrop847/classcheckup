import 'package:classcheckup/components/subcard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashBoard extends StatefulWidget {
  final String uid;
  const DashBoard({super.key, required this.uid});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('subdata')
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var userData = snapshot.data!.data() as Map<String, dynamic>?;

            if (userData == null || !userData.containsKey('subjects')) {
              return const Text('No subjects found.');
            }

            List<dynamic> subjectsData = userData['subjects'] as List<dynamic>;

            if (subjectsData.isEmpty) {
              return const Text('No subjects found.');
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemCount: subjectsData.length,
              itemBuilder: (context, index) {
                var subject = subjectsData[index];
                String subname = subject['subname'] as String;

                String id = widget.uid;

                return SubCard(
                  subname: subname,
                  id: id,
                  index: index,
                  curr: subject['curr'],
                  total: subject['total'],
                );
              },
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
