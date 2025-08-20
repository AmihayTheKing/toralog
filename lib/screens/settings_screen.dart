import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zman_limud_demo/providers/date_type_provider.dart';
import 'package:zman_limud_demo/util/general_util.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void changeDateType(BuildContext context, WidgetRef ref, DateType dateType) {
    ref.read(dateTypeProvider.notifier).setDateType(dateType);
    Navigator.of(context).pop();
  }

  Widget createDateTypeTile(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding:
          EdgeInsets.symmetric(horizontal: getAdaptiveWidth(context, 8)),
      dense: true,
      onTap: () => showDateTypeSelection(context),
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'סוג תאריך',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: getAdaptiveHeight(context, 20),
              ),
        ),
      ),
      subtitle: Align(
        alignment: Alignment.centerRight,
        child: Text(
          ref.watch(dateTypeProvider) == DateType.jewish
              ? 'תאריך עברי'
              : 'תאריך לועזי',
        ),
      ),
    );
  }

  void showDateTypeSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer(builder: (context, ref, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getAdaptiveHeight(context, 8),
                    horizontal: getAdaptiveWidth(context, 24),
                  ),
                  child: Text(
                    'סוג תאריך',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: getAdaptiveHeight(context, 20),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              RadioListTile(
                title: Text('תאריך עברי'),
                onChanged: (value) =>
                    changeDateType(context, ref, DateType.jewish),
                value: DateType.jewish,
                groupValue: ref.watch(dateTypeProvider),
              ),
              RadioListTile(
                title: Text('תאריך לועזי'),
                onChanged: (value) =>
                    changeDateType(context, ref, DateType.gregorian),
                value: DateType.gregorian,
                groupValue: ref.watch(dateTypeProvider),
              ),
              SizedBox(height: getAdaptiveHeight(context, 32)),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('הגדרות'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Card.filled(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getAdaptiveWidth(context, 16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              createDateTypeTile(context, ref),
              Divider(),
              SizedBox(
                height: getAdaptiveHeight(context, 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
