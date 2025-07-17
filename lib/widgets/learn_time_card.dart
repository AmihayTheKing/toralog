import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zman_limud_demo/providers/date_type_provider.dart';
import 'package:zman_limud_demo/util/category.dart';
import 'package:zman_limud_demo/models/learn_time.dart';

class LearnTimeCard extends ConsumerWidget {
  final LearnTime learnTime;
  final Function(LearnTime) editButtonFunction;

  const LearnTimeCard({
    super.key,
    required this.learnTime,
    required this.editButtonFunction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

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
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  onPressed: () => editButtonFunction(learnTime),
                ),
              ],
            ),
            SizedBox(height: 0),
            Row(
              children: [
                Text(
                  learnTime.endTime.format(context),
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 17),
                ),
                SizedBox(width: 4),
                Text(
                  '\u2014',
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 17),
                ),
                SizedBox(width: 4),
                Text(
                  learnTime.startTime.format(context),
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 17),
                ),
                Spacer(),
                Text(
                  ref.watch(dateTypeProvider) == DateType.jewish
                      ? learnTime.jewishFormattedDate
                      : learnTime.formattedDate,
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 16),
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  learnTime.formattedHours,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
