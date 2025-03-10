import 'package:flutter/material.dart';

class SingleColorChartBar extends StatelessWidget {
  const SingleColorChartBar(
      {super.key, required this.fillFactor, required this.color});

  final double fillFactor;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: FractionallySizedBox(
          heightFactor: fillFactor,
          alignment: Alignment.bottomCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
