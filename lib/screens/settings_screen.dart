import 'package:flutter/material.dart';
import 'package:zman_limud_demo/util/general_util.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key, required this.selectedDateType});

  DateType selectedDateType;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(widget.selectedDateType);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Column(
          children: [
            Text(
              'סוג תאריך',
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).colorScheme.onPrimary),
            ),
            RadioListTile(
              value: DateType.jewish,
              groupValue: widget.selectedDateType,
              onChanged: (value) => setState(
                () => widget.selectedDateType = value!,
              ),
              title: const Text('תאריך עברי'),
            ),
            RadioListTile(
              value: DateType.gregorian,
              groupValue: widget.selectedDateType,
              onChanged: (value) => setState(
                () => widget.selectedDateType = value!,
              ),
              title: const Text('תאריך לועזי'),
            ),
          ],
        ),
      ),
    );
  }
}
