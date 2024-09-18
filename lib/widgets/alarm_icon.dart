import 'package:flutter/material.dart';


class AlarmIconWidget extends StatefulWidget {
  final bool hasAlarm;

  const AlarmIconWidget({super.key, required this.hasAlarm});
  @override
  AlarmIconWidgetState createState() => AlarmIconWidgetState();
}


class AlarmIconWidgetState extends State<AlarmIconWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.hasAlarm
        ? const Icon(
            Icons.alarm,
            color: Colors.white,
          )
        : const SizedBox();
  }
}