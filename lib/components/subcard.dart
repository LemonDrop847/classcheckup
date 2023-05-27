import 'package:flutter/material.dart';

import '../pages/subject.dart';

class SubCard extends StatelessWidget {
  final String subname;
  final String id;
  final double attend;
  const SubCard(
      {super.key,
      required this.subname,
      required this.id,
      required this.attend});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Card(
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubjectPage(
                      value: attend,
                      sub: subname,
                    )),
          ),
          child: Text(
            subname,
            style: TextStyle(
              fontSize: 35,
            ),
          ),
        ),
      ),
    );
  }
}
