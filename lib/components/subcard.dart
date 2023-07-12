import 'package:classcheckup/components/gauge.dart';
import 'package:classcheckup/components/marquee.dart';
import 'package:flutter/material.dart';
import '../pages/subject.dart';

class SubCard extends StatefulWidget {
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
  State<SubCard> createState() => _SubCardState();
}

class _SubCardState extends State<SubCard> {
  bool longPressed = false;
  @override
  Widget build(BuildContext context) {
    double attend = widget.curr == 0 ? 0 : widget.curr / widget.total * 100;
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
                      curr: widget.curr,
                      total: widget.total,
                      sub: widget.subname,
                      index: widget.index,
                      uid: widget.id,
                    )),
          ),
          child: Column(
            children: [
              Expanded(
                child: Gauge(value: attend),
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    longPressed = !longPressed;
                  });
                },
                child: longPressed
                    ? MarqueeWidget(
                        direction: Axis.horizontal,
                        child: Text(
                          widget.subname,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: 35,
                            fontFamily: 'Architect',
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                        ),
                      )
                    : Text(
                        widget.subname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'Architect',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
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
