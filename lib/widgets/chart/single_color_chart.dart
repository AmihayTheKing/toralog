import 'package:flutter/material.dart';
import 'package:zman_limud_demo/util/general_util.dart';
import 'package:zman_limud_demo/widgets/chart/single_color_chart_bar.dart';
import 'package:zman_limud_demo/models/learn_times_bucket.dart';
import 'package:zman_limud_demo/util/category.dart';

class SingleColorChart extends StatelessWidget {
  const SingleColorChart(
      {super.key,
      required this.buckets,
      required this.dateType,
      required this.onBarTap});

  final List<LearnTimesBucket> buckets;
  final DateType dateType;
  final void Function(Category) onBarTap;

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
                    SingleColorChartBar(
                      color: categoryColors[bucket.countedThing]
                          ?.withOpacity(0.77),
                      fillFactor: maxTotalExpense == 0
                          ? 0
                          : bucket.amount / maxTotalExpense,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${categoryChartLabels[bucket.countedThing]}',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
