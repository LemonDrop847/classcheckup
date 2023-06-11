import 'package:classcheckup/components/gauge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubjectPage extends StatefulWidget {
  final double value;
  final int curr, total;
  final String sub, uid;
  final int index;

  const SubjectPage({
    Key? key,
    required this.value,
    required this.uid,
    required this.sub,
    required this.index,
    required this.curr,
    required this.total,
  }) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _subjectsData = [];
  bool _showTick = false;
  late AnimationController _controller;

  bool checkLow() {
    if (widget.value >= 65) return true;
    return false;
  }

  int tot = 0, now = 0;

  @override
  void initState() {
    super.initState();
    _fetchSubjectsData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchSubjectsData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('subdata')
              .doc(widget.uid)
              .get();

      if (snapshot.exists) {
        final subData = snapshot.data();
        if (subData != null && subData.containsKey('subjects')) {
          final List<dynamic> subjectsList =
              subData['subjects'] as List<dynamic>;

          final List<Map<String, dynamic>> subjectsData = [];

          for (final subject in subjectsList) {
            if (subject is Map<String, dynamic> &&
                subject.containsKey('subname') &&
                subject.containsKey('curr') &&
                subject.containsKey('total')) {
              subjectsData.add(subject);
            }
          }

          setState(() {
            _subjectsData = subjectsData;
            tot = widget.total;
            now = widget.curr;
          });
        }
      }
    } catch (e) {
      print('Error fetching subjects data: $e');
    }
  }

  Future<void> _updateSubjectsData(
      List<Map<String, dynamic>> updatedSubjectsData) async {
    try {
      await FirebaseFirestore.instance
          .collection('subdata')
          .doc(widget.uid)
          .update({'subjects': updatedSubjectsData});

      setState(() {
        _showTick = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _showTick = false;
      });
    } catch (e) {
      print('Error updating subjects data: $e');
    }
  }

  Future<void> increase() async {
    try {
      setState(() {
        tot++;
        now++;
      });

      final List<Map<String, dynamic>> updatedSubjectsData =
          List.from(_subjectsData);

      updatedSubjectsData[widget.index]['total'] = tot;
      updatedSubjectsData[widget.index]['curr'] = now;

      await _updateSubjectsData(updatedSubjectsData);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sub),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onDoubleTap: increase,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: _showTick
                    ? TickAnimation(controller: _controller)
                    : SizedBox(
                        height: 300,
                        child: Gauge(value: widget.value),
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.sub,
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
            Text(
              checkLow() ? 'You are good!' : 'Attend more classes!',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TickAnimation extends StatefulWidget {
  final AnimationController controller;

  const TickAnimation({Key? key, required this.controller}) : super(key: key);

  @override
  _TickAnimationState createState() => _TickAnimationState();
}

class _TickAnimationState extends State<TickAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animation = Tween<double>(begin: 0, end: 1).animate(widget.controller);
    widget.controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 300,
      ),
    );
  }
}
