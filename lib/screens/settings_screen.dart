import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zman_limud_demo/providers/date_type_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                dense: true,
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      Consumer(builder: (context, ref, child) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 24,
                              ),
                              child: Text(
                                'סוג תאריך',
                                textAlign: TextAlign.right,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          RadioListTile(
                            title: Text('תאריך עברי'),
                            onChanged: (value) {
                              ref
                                  .read(dateTypeProvider.notifier)
                                  .setDateType(value!);
                              Navigator.of(context).pop();
                            },
                            value: DateType.jewish,
                            groupValue: ref.watch(dateTypeProvider),
                          ),
                          RadioListTile(
                            title: Text('תאריך לועזי'),
                            onChanged: (value) {
                              ref
                                  .read(dateTypeProvider.notifier)
                                  .setDateType(value!);
                              Navigator.of(context).pop();
                            },
                            value: DateType.gregorian,
                            groupValue: ref.watch(dateTypeProvider),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'סוג תאריך',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 20,
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
              ),
              Divider(),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
