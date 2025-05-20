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
  int weekDifference = 0;
  DateTime _dateOfDisplayedData = DateTime.now();
  Category _categoryOfDisplayedData = Category.other;
  List<LearnTimesBucket<Category>> _currentShownDayBuckets = [];
  late bool displayHorizontalLine;

  Map<DateTime, LearnTimesBucket<DateTime>> _currentWeekBucket(DateTime date) {
    DateTime startOfWeek = date.subtract(
      Duration(days: date.weekday == 7 ? 0 : date.weekday),
    );

    Map<DateTime, LearnTimesBucket<DateTime>> map = {};
    for (var i = 0; i <= 6; i++) {
      DateTime currentDate = startOfWeek.copyWith(day: startOfWeek.day + i);

      map[currentDate.onlyDate] = LearnTimesBucket<DateTime>.fromList(
        allLearnTimes: widget.appState.widget.learnTimes,
        countedThing: currentDate.onlyDate,
        filter: (learnTime) => learnTime.date.isSameDate(currentDate),
      );
    }
    return map;
  }

  void changeDateChartData(
      DateTime date, List<LearnTimesBucket<Category>> currentShownDayBuckets) {
    setState(
      () {
        _dateOfDisplayedData = date;
        _currentShownDayBuckets = currentShownDayBuckets;
        displayHorizontalLine =
            _currentShownDayBuckets.any((bucket) => bucket.amount > 0);
      },
    );
  }

  void changeCategoryChartData(Category category) {
    setState(() {
      _categoryOfDisplayedData = category;
    });
  }

  List<LearnTimesBucket<Category>> getInnerBuckets(
      LearnTimesBucket<DateTime> bucket) {
    return Category.values.map((category) {
      return LearnTimesBucket<Category>.fromList(
        allLearnTimes: bucket.learnTimes,
        countedThing: category,
        filter: (learnTime) => learnTime.category == category,
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _currentShownDayBuckets.addAll(
      getInnerBuckets(
        _currentWeekBucket(DateTime.now())[DateTime.now().onlyDate]!,
      ),
    );
    displayHorizontalLine =
        _currentShownDayBuckets.any((bucket) => bucket.amount > 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 90, top: 10),
        child: Column(
          children: [
            Card.filled(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget
                            .appState
                            .widget
                            .categoryBuckets[_categoryOfDisplayedData]!
                            .formattedAmount,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                  SingleColorChart(
                    onBarTap: changeCategoryChartData,
                    buckets:
                        widget.appState.widget.categoryBuckets.values.toList(),
                    dateType: widget.appState.dateType,
                  ),
                ],
              ),
            ),
            Card.filled(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _currentWeekBucket(_dateOfDisplayedData)[
                                  _dateOfDisplayedData.onlyDate]!
                              .formattedAmount,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: PageController(
                          initialPage: 0,
                        ),
                        itemBuilder: (context, index) => MultiColorChart(
                          onBarTap: changeDateChartData,
                          buckets: _currentWeekBucket(
                            DateTime.now().add(Duration(days: (-index) * 7)),
                          ).values.toList(),
                          dateType: widget.appState.dateType,
                        ),
                      ),
                    ),
                    if (displayHorizontalLine)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          thickness: 2,
                        ),
                      ),
                    for (var bucket in _currentShownDayBuckets)
                      if (bucket.amount > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: categoryColors[bucket.countedThing]
                                        ?.withOpacity(0.77),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${categoryNames[bucket.countedThing]}',
                                style: TextStyle(fontSize: 15),
                              ),
                              Spacer(),
                              Text(
                                bucket.formattedAmount,
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
