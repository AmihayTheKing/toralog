import 'package:flutter/material.dart';
import 'package:zman_limud_demo/util/general_util.dart';

class ChartLine extends StatelessWidget {
  final num largestAmount;

  const ChartLine(this.largestAmount, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${largestAmount % 1 == 0 ? largestAmount.toInt() : largestAmount} ש\'',
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: getAdaptiveHeight(context, 10),
                ),
            strutStyle: StrutStyle(
              forceStrutHeight: true,
              height: 0,
            ),
          ),
          SizedBox(width: getAdaptiveWidth(context, 8)),
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              thickness: getAdaptiveHeight(context, 2),
            ),
          ),
        ],
      ),
    );
  }
}
