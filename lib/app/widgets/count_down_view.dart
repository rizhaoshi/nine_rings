import 'dart:async';
import 'package:flutter/material.dart';
import '../../common/utils/date_time_util.dart';

class CountDownView extends StatefulWidget {
  final DateTime beginTime;
  final int targetDays;
  final Color color;

  const CountDownView({required this.beginTime, required this.targetDays, required this.color});

  @override
  State<CountDownView> createState() => _CountDownViewState();
}

class _CountDownViewState extends State<CountDownView> {
  late Timer? _timer;
  int? _seconds;

  void _startTimer() {
    const period = Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      setState(() {
        _seconds = _seconds! - 1;
      });
      if (_seconds == 0) {
        _cancelTimer();
      }
    });
  }

  void _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void initState() {
    super.initState();
    DateTime endTime = widget.beginTime.add(Duration(days: widget.targetDays));
    Duration diff = endTime.difference(DateTime.now());
    _seconds = diff.inSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 166,
      alignment: Alignment.center,
      child: Text(second2DHMS(_seconds!), textAlign: TextAlign.center, style: TextStyle(color: widget.color, fontSize: 18.0, fontWeight: FontWeight.w400)),
    );
  }
}
