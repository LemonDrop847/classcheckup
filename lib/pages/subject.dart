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

  bool missed = false;

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
        missed = false;
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

  Future<void> decrease() async {
    try {
      setState(() {
        missed = true;
        tot++;
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
        title: Text(
          widget.sub,
          style: const TextStyle(
            fontFamily: 'Avenir',
            fontSize: 27,
          ),
        ),
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
                    ? TickAnimation(
                        controller: _controller,
                        missed: missed,
                      )
                    : SizedBox(
                        height: 250,
                        child: Gauge(value: widget.value),
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.sub,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                fontFamily: 'Itim',
                decoration: TextDecoration.underline,
              ),
            ),
            Text(
              maxLines: 1,
              checkLow() ? 'You are good!' : 'Attend more classes!',
              style: const TextStyle(
                fontFamily: 'SourceSans',
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FloatingActionButton.extended(
              onPressed: increase,
              icon: const Icon(Icons.check),
              label: const Text(
                "Attended Class",
                style: TextStyle(
                  fontFamily: 'Architect',
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton.extended(
              onPressed: decrease,
              icon: const Icon(Icons.close),
              label: const Text(
                "Missed Class",
                style: TextStyle(
                  fontFamily: 'Architect',
                  fontSize: 18,
                ),
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
  final bool missed;

  const TickAnimation(
      {Key? key, required this.controller, required this.missed})
      : super(key: key);

  @override
  _TickAnimationState createState() => _TickAnimationState();
}

class _TickAnimationState extends State<TickAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  bool tick = true;
  @override
  void initState() {
    tick = widget.missed;
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
      child: Icon(
        tick ? Icons.close_outlined : Icons.check_circle,
        color: tick ? Colors.red : Colors.green,
        size: 250,
      ),
    );
  }
}
