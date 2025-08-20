import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zman_limud_demo/providers/date_type_provider.dart';
import 'package:zman_limud_demo/util/category.dart';
import 'package:zman_limud_demo/models/learn_time.dart';
import 'package:zman_limud_demo/util/general_util.dart';
import 'package:zman_limud_demo/widgets/edit_menu.dart';

class LearnTimeCard extends ConsumerWidget {
  final LearnTime learnTime;

  const LearnTimeCard({super.key, required this.learnTime});

  void editButtonFunction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => EditMenu(
        learnTime: learnTime,
      ),
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
    );
  }

  Widget _createFirstRow(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Text(
            learnTime.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: getAdaptiveHeight(context, 20),
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          onPressed: () {
            editButtonFunction(context);
          },
        ),
      ],
    );
  }

  Widget _createSecondRow(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          learnTime.endTime.format(context),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: getAdaptiveHeight(context, 17),
              ),
        ),
        SizedBox(width: getAdaptiveWidth(context, 4)),
        Text(
          '\u2014',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: getAdaptiveHeight(context, 17),
              ),
        ),
        SizedBox(width: getAdaptiveWidth(context, 4)),
        Text(
          learnTime.startTime.format(context),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: getAdaptiveHeight(context, 17),
              ),
        ),
        Spacer(),
        Text(
          ref.watch(dateTypeProvider) == DateType.jewish
              ? learnTime.jewishFormattedDate
              : learnTime.formattedDate,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: getAdaptiveHeight(context, 16),
              ),
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }

  Widget _createThirdRow(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          learnTime.formattedHours,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: getAdaptiveHeight(context, 16),
                fontWeight: FontWeight.w600,
              ),
          textDirection: TextDirection.rtl,
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: getAdaptiveWidth(context, 12),
            vertical: getAdaptiveHeight(context, 4),
          ),
          decoration: BoxDecoration(
            color: categoryColors[learnTime.category]?.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            categoryNames[learnTime.category]!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: getAdaptiveHeight(context, 14),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card.filled(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: getAdaptiveHeight(context, 12),
          horizontal: getAdaptiveWidth(context, 16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createFirstRow(context, ref),
            _createSecondRow(context, ref),
            SizedBox(height: getAdaptiveHeight(context, 8)),
            _createThirdRow(context, ref),
          ],
        ),
      ),
    );
  }
}
