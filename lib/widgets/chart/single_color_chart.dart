import 'package:flutter/material.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:zman_limud_demo/util/general_util.dart';
import 'package:zman_limud_demo/widgets/chart/single_color_chart_bar.dart';
import 'package:zman_limud_demo/models/learn_times_bucket.dart';
import 'package:zman_limud_demo/util/category.dart';

class SingleColorChart extends StatelessWidget {
  const SingleColorChart(
      {super.key, required this.buckets, required this.dateType});

  final List<LearnTimesBucket> buckets;
  final DateType dateType;

  double get maxTotalExpense {
    double maxTotalExpense = 0;

    for (final bucket in buckets) {
      if (bucket.amount > maxTotalExpense) {
        maxTotalExpense = bucket.amount;
      }
    }

    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            for (final bucket in buckets)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SingleColorChartBar(
                      color: bucket.countedThing is Category
                          ? categoryColors[bucket.countedThing]
                              ?.withOpacity(0.77)
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.9),
                      fillFactor: maxTotalExpense == 0
                          ? 0
                          : bucket.amount / maxTotalExpense,
                    ),
                    SizedBox(height: 8),
                    bucket.countedThing is Category
                        ? Text(
                            '${categoryChartLabels[bucket.countedThing]}',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                          )
                        : dateType == DateType.jewish
                            ? Text(
                                JewishDate.fromDateTime(bucket.countedThing)
                                    .getFormattedDateForChart(),
                                style: TextStyle().copyWith(fontSize: 13),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                dateFormatForChart.format(bucket.countedThing),
                                textAlign: TextAlign.center,
                              ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
