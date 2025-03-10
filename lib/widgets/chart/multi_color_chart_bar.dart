import 'package:flutter/material.dart';
import 'package:zman_limud_demo/models/learn_times_bucket.dart';
import 'package:zman_limud_demo/util/category.dart';

class MultiColorChartBar extends StatelessWidget {
  MultiColorChartBar(
      {super.key, required this.generalFillFactor, required this.bucket}) {
    for (var category in Category.values) {
      LearnTimesBucket tempBucket = LearnTimesBucket.fromList(
        allLearnTimes: bucket.learnTimes,
        countedThing: category,
        filter: (learnTime) => learnTime.category == category,
      );
      allFillFactors[category] =
          tempBucket.amount == 0 ? 0 : tempBucket.amount / bucket.amount;
    }
  }

  final double generalFillFactor;
  final LearnTimesBucket bucket;
  final Map<Category, double> allFillFactors = {};

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FractionallySizedBox(
          heightFactor: generalFillFactor,
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: LayoutBuilder(
              builder: (context, constraints) => Column(
                mainAxisSize: MainAxisSize.max,
                spacing: 0,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var category in Category.values)
                    SizedBox(
                      height: (allFillFactors[category] ?? 0) *
                          constraints.minHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: categoryColors[category]?.withOpacity(0.77),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
