import 'package:flutter/material.dart';
import 'package:zman_limud_demo/main.dart';
import 'package:zman_limud_demo/models/learn_times_bucket.dart';
import 'package:zman_limud_demo/util/category.dart';
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
  DateTime _dateOfDisplayedData = DateTime.now();
  Category _categoryOfDisplayedData = Category.other;

  Map<DateTime, LearnTimesBucket> _currentWeekBucket(DateTime date) {
    DateTime startOfWeek = date.subtract(
      Duration(days: date.weekday == 7 ? 0 : date.weekday),
    );

    Map<DateTime, LearnTimesBucket> map = {};
    for (var i = 0; i <= 6; i++) {
      DateTime currentDate = startOfWeek.copyWith(day: startOfWeek.day + i);

      map[currentDate] = LearnTimesBucket.fromList(
        allLearnTimes: widget.appState.widget.learnTimes,
        countedThing: currentDate,
        filter: (learnTime) => learnTime.date.isSameDate(currentDate),
      );
    }
    return map;
  }

  void showDayData(DateTime date) {
    setState(() => _dateOfDisplayedData = date);
  }

  void showCategoryData(Category category) {
    setState(() => _categoryOfDisplayedData = category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 90,
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Card.filled(
                child: Column(
                  children: [
                    Text(widget
                        .appState
                        .widget
                        .categoryBuckets[_categoryOfDisplayedData]!
                        .formmettedAmount),
                    SingleColorChart(
                      buckets: widget.appState.widget.categoryBuckets.values
                          .toList(),
                      dateType: widget.appState.dateType,
                    ),
                  ],
                ),
              ),
              Card.filled(
                child: Column(
                  children: [
                    Text(_currentWeekBucket(
                            _dateOfDisplayedData)[_dateOfDisplayedData]!
                        .formmettedAmount),
                    MultiColorChart(
                      buckets: _currentWeekBucket(
                        DateTime.now(),
                      ).values.toList(),
                      dateType: widget.appState.dateType,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
