import 'package:flutter/material.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:zman_limud_demo/util/category.dart';
import 'package:zman_limud_demo/util/general_util.dart';
import 'package:zman_limud_demo/widgets/chart/multi_color_chart_bar.dart';
import 'package:zman_limud_demo/models/learn_times_bucket.dart';

class MultiColorChart extends StatelessWidget {
  const MultiColorChart(
      {super.key,
      required this.buckets,
      required this.dateType,
      required this.onBarTap});

  final List<LearnTimesBucket<DateTime>> buckets;
  final DateType dateType;
  final void Function(DateTime, List<LearnTimesBucket<Category>>) onBarTap;

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.amount > maxTotalExpense) {
        maxTotalExpense = bucket.amount;
      }
    }

    return maxTotalExpense;
  }

  List<LearnTimesBucket<Category>> getInnerBuckets(
      LearnTimesBucket<DateTime> bucket) {
    List<LearnTimesBucket<Category>> tempBuckets = [];
    for (var category in Category.values) {
      tempBuckets.add(
        LearnTimesBucket<Category>.fromList(
          allLearnTimes: bucket.learnTimes,
          countedThing: category,
          filter: (learnTime) => learnTime.category == category,
        ),
      );
    }
    return tempBuckets;
  }

  Map<Category, double> getInnerFillPercentages(
      LearnTimesBucket<DateTime> bucket) {
    Map<Category, double> fillPercent = {};
    for (var category in Category.values) {
      LearnTimesBucket<Category> tempBucket =
          LearnTimesBucket<Category>.fromList(
        allLearnTimes: bucket.learnTimes,
        countedThing: category,
        filter: (learnTime) => learnTime.category == category,
      );
      fillPercent[category] =
          tempBucket.amount == 0 ? 0 : tempBucket.amount / bucket.amount;
    }
    return fillPercent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final bucket in buckets)
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                onTap: () =>
                    onBarTap(bucket.countedThing, getInnerBuckets(bucket)),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MultiColorChartBar(
                      innerFillPercentages: getInnerFillPercentages(bucket),
                      generalFillFactor: maxTotalExpense == 0
                          ? 0
                          : bucket.amount / maxTotalExpense,
                    ),
                    SizedBox(height: 8),
                    dateType == DateType.jewish
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: Text(
                              JewishDate.fromDateTime(bucket.countedThing)
                                  .getFormattedDateForChart(),
                              style: TextStyle().copyWith(fontSize: 11.5),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Text(
                            dateFormatForChart.format(bucket.countedThing),
                            textAlign: TextAlign.center,
                          ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
