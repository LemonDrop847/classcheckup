import 'package:classcheckup/components/gauge.dart';
import 'package:flutter/material.dart';

import '../pages/subject.dart';

class SubCard extends StatelessWidget {
  final String subname;
  final String id;
  final int curr, total;
  final int index;
  const SubCard(
      {super.key,
      required this.subname,
      required this.id,
      required this.index,
      required this.curr,
      required this.total});

  @override
  Widget build(BuildContext context) {
    double attend = curr == 0 ? 0 : curr / total * 100;
    return SizedBox(
      height: 100,
      width: 100,
      child: Card(
        color: Theme.of(context).canvasColor,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubjectPage(
                      value: attend,
                      curr: curr,
                      total: total,
                      sub: subname,
                      index: index,
                      uid: id,
                    )),
          ),
          child: Column(
            children: [
              Expanded(
                child: Gauge(value: attend),
              ),
              Text(
                subname,
                style: TextStyle(
                  fontSize: 30,
                  // fontFamily: 'Fallscoming',
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
