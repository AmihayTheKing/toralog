import 'package:flutter/material.dart';
import 'package:zman_limud_demo/main.dart';
import 'package:zman_limud_demo/models/learn_times_bucket.dart';
import 'package:zman_limud_demo/util/general_util.dart';
import 'package:zman_limud_demo/widgets/chart/multi_color_chart.dart';
import 'package:zman_limud_demo/widgets/chart/single_color_chart.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key, required this.appState});

  final AppState appState;

  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  List<LearnTimesBucket> get _currentWeekBucket {
    DateTime startOfWeek = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday == 7 ? 0 : DateTime.now().weekday),
    );

    List<LearnTimesBucket> list = [];
    for (var i = 0; i <= 6; i++) {
      list.add(
        LearnTimesBucket.fromList(
          allLearnTimes: widget.appState.widget.learnTimes,
          countedThing: startOfWeek.copyWith(day: startOfWeek.day + i),
          filter: (learnTime) => learnTime.date
              .isSameDate(startOfWeek.copyWith(day: startOfWeek.day + i)),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          children: [
            SizedBox(height: 10),
            SingleColorChart(
              buckets: widget.appState.widget.categoryBuckets.values.toList(),
              dateType: widget.appState.dateType,
            ),
            MultiColorChart(
              buckets: _currentWeekBucket,
              dateType: widget.appState.dateType,
            ),
            SingleColorChart(
              buckets: _currentWeekBucket,
              dateType: widget.appState.dateType,
            ),
          ],
        ),
      ),
    );
  }
}
