import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimelineTile extends StatefulWidget {
  MyTimelineTile(
      {Key? key,
      required this.isFirst,
      required this.isLast,
      required this.isDone,
      required this.title,
      required this.subtitle})
      : super(key: key);
  final bool isFirst;
  final bool isLast;
  final bool isDone;
  final String title;
  final String subtitle;

  @override
  State<MyTimelineTile> createState() => _MyTimelineTileState();
}

class _MyTimelineTileState extends State<MyTimelineTile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: TimelineTile(
        isFirst: widget.isFirst,
        isLast: widget.isLast,
        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 40,
          indicator: Container(
            decoration: BoxDecoration(
              color: widget.isDone ? Colors.blue : Colors.blue[200],
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.check,
                color: widget.isDone ? Colors.white : Colors.transparent,
              ),
            ),
          ),
        ),
        beforeLineStyle: const LineStyle(
          color: Colors.lightBlue,
          thickness: 3,
        ),
        endChild: Container(
          padding: const EdgeInsets.all(13),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.isDone ? Colors.blue : Colors.blue[200],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
