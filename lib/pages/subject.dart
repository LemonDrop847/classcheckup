import 'package:classcheckup/components/gauge.dart';
import 'package:flutter/material.dart';

class SubjectPage extends StatefulWidget {
  final double value;
  final String sub;
  const SubjectPage({Key? key, required this.value, required this.sub})
      : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  bool checkLow() {
    if (widget.value >= 65) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sub),
      ),
      body: Column(
        children: [
          Gauge(value: widget.value),
          Text(widget.sub),
          Text(checkLow() ? 'You are good' : 'Attend more classes')
        ],
      ),
    );
  }
}
