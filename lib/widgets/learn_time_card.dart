import 'package:flutter/material.dart';
import 'package:zman_limud_demo/util/category.dart';
import 'package:zman_limud_demo/models/learn_time.dart';
import 'package:zman_limud_demo/util/general_util.dart';

class LearnTimeCard extends StatelessWidget {
  final LearnTime learnTime;
  final DateType dateType;
  final Function(LearnTime) editFunction;

  const LearnTimeCard({
    super.key,
    required this.learnTime,
    required this.dateType,
    required this.editFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    learnTime.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.brightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () => editFunction(learnTime),
                ),
              ],
            ),
            SizedBox(height: 0),
            Row(
              children: [
                Text(
                  learnTime.endTime.format(context),
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(width: 4),
                Text('\u2014'),
                SizedBox(width: 4),
                Text(
                  learnTime.startTime.format(context),
                  style: TextStyle(fontSize: 17),
                ),
                Spacer(),
                Text(
                  dateType == DateType.jewish
                      ? learnTime.jewishFormattedDate
                      : learnTime.formattedDate,
                  style: TextStyle(fontSize: 16),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  learnTime.formattedHours,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  textDirection: TextDirection.rtl,
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryColors[learnTime.category]?.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    categoryNames[learnTime.category]!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
