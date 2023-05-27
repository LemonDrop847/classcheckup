import 'package:flutter/material.dart';
import './subject.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubjectPage(
                      value: 65,
                      sub: "Random",
                    )),
          ),
          child: Text('Subject Test'),
        ),
      ),
    );
  }
}
