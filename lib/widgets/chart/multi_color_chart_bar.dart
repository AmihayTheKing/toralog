import 'package:flutter/material.dart';
import 'package:zman_limud_demo/util/category.dart';

class MultiColorChartBar extends StatelessWidget {
  const MultiColorChartBar(
      {super.key,
      required this.generalFillFactor,
      required this.innerFillPercentages});

  final double generalFillFactor;
  final Map<Category, double> innerFillPercentages;

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
                      height: (innerFillPercentages[category] ?? 0) *
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
