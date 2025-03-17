import 'package:flutter/material.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:zman_limud_demo/util/general_util.dart';
import 'package:zman_limud_demo/widgets/chart/multi_color_chart_bar.dart';
import 'package:zman_limud_demo/models/learn_times_bucket.dart';

class MultiColorChart extends StatelessWidget {
  const MultiColorChart(
      {super.key,
      required this.buckets,
      required this.dateType,
      required this.onBarTap});

  final List<LearnTimesBucket> buckets;
  final DateType dateType;
  final void Function(DateTime) onBarTap;

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
                onTap: () => onBarTap(bucket.countedThing),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MultiColorChartBar(
                      bucket: bucket,
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
