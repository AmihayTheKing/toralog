import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:zman_limud_demo/hebrewDatePicker/cupertino_hebrew_date_picker.dart';
import 'package:zman_limud_demo/hebrewDatePicker/material_hebrew_date_picker.dart';
import 'package:zman_limud_demo/providers/learn_times_provider.dart';
import 'package:zman_limud_demo/util/category.dart';
import 'package:zman_limud_demo/util/general_util.dart';
import 'package:zman_limud_demo/models/learn_time.dart';

class EditMenu extends ConsumerStatefulWidget {
  const EditMenu({super.key, required this.learnTime});

  final LearnTime learnTime;

  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends ConsumerState<EditMenu> {
  late final TextEditingController _titleController =
      TextEditingController.fromValue(
    TextEditingValue(text: widget.learnTime.title),
  );
  late TimeOfDay _pickedStartTime = widget.learnTime.startTime;
  late TimeOfDay _pickedEndTime = widget.learnTime.endTime;
  late DateTime _pickedDate = widget.learnTime.date;
  late Category _category = widget.learnTime.category;

  void _submit() async {
    bool ifReturn = false;

    if (_titleController.text.isEmpty) {
      if (Platform.isIOS) {
        await showCupertinoDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text('אתה בטוח שאתה לא רוצה להוסיף כותרת?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ifReturn = true;
                },
                child: Text('בטל'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('אישור'),
              ),
            ],
          ),
        );
      }

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text('אתה בטוח שאתה לא רוצה להוסיף כותרת?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                ifReturn = true;
              },
              child: Text('בטל'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('אישור'),
            ),
          ],
        ),
      );
    }

    if (ifReturn) {
      return;
    }

    if (kDebugMode) {
      print(_pickedDate);
    }
    ref.read(learnTimesProvider.notifier).updateLearnTime(
          LearnTime(
            id: widget.learnTime.id,
            title: _titleController.text,
            startTime: _pickedStartTime,
            endTime: _pickedEndTime,
            date: _pickedDate,
            category: _category,
          ),
        );
    Navigator.pop(context);
  }

  void _chooseStartTime() async {
    if (Platform.isAndroid) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              _pickedStartTime.hour,
              _pickedStartTime.minute,
            ),
            use24hFormat: true,
            onDateTimeChanged: (DateTime value) {
              _pickedStartTime = TimeOfDay.fromDateTime(value);
              setState(() {});
            },
          ),
        ),
      );
    } else {
      _pickedStartTime = await showTimePicker(
            context: context,
            initialTime: _pickedStartTime,
          ) ??
          _pickedStartTime;
      setState(() {});
    }
  }

  void _chooseEndTime() async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              _pickedEndTime.hour,
              _pickedEndTime.minute,
            ),
            use24hFormat: true,
            onDateTimeChanged: (DateTime value) {
              _pickedEndTime = TimeOfDay.fromDateTime(value);
              setState(() {});
            },
          ),
        ),
      );
    } else {
      _pickedEndTime = await showTimePicker(
            context: context,
            initialTime: _pickedEndTime,
          ) ??
          _pickedEndTime;
      setState(() {});
    }
  }

  void _chooseDateGregorian() async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _pickedDate,
            minimumDate: DateTime(_pickedDate.year - 1),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime value) => _pickedDate = value,
          ),
        ),
      );
    } else {
      _pickedDate = (await showDatePicker(
            context: context,
            initialDate: _pickedDate,
            firstDate: DateTime(_pickedDate.year - 1),
            lastDate: DateTime.now(),
          )) ??
          _pickedDate;
    }
    setState(() {});
  }

  void _chooseDateJewish() async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => SizedBox(
          height: 200,
          child: CupertinoHebrewDatePicker(
            context: context,
            onDateChanged: (DateTime value) => _pickedDate = value,
            onConfirm: (DateTime value) {
              setState(
                () => value.isAfter(DateTime.now())
                    ? _pickedDate = DateTime.now()
                    : _pickedDate = value,
              );
            },
            initialDate: _pickedDate,
            confirmText: 'אישור',
            todaysDateTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    } else {
      await showMaterialHebrewDatePicker(
        context: context,
        initialDate: _pickedDate,
        firstDate: _pickedDate.subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 30)),
        hebrewFormat: true,
        onConfirmDate: (date) => setState(() => _pickedDate = date),
        onDateChange: (DateTime value) {},
        theme: GeneralUtil.getHebrewDatePickerTheme(context),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double hourPickRowFontSize = 20;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'כותרת',
                labelStyle: TextStyle()
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _chooseEndTime,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.all(0),
                      ),
                    ),
                    child: Text(
                      _pickedEndTime.format(context),
                      style:
                          TextStyle().copyWith(fontSize: hourPickRowFontSize),
                    ),
                  ),
                  Text(
                    'עד שעה:',
                    style: TextStyle(
                        fontSize: hourPickRowFontSize,
                        color: Theme.of(context).colorScheme.primary),
                    textDirection: TextDirection.rtl,
                  ),
                  SizedBox(width: 6),
                  Text(
                    '\u2014', // -
                    style: TextStyle(
                      fontSize: hourPickRowFontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 6),
                  TextButton(
                    onPressed: _chooseStartTime,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.all(0),
                      ),
                    ),
                    child: Text(
                      _pickedStartTime.format(context),
                      style:
                          TextStyle().copyWith(fontSize: hourPickRowFontSize),
                    ),
                  ),
                  Text(
                    'משעה:',
                    style: TextStyle(
                        fontSize: hourPickRowFontSize,
                        color: Theme.of(context).colorScheme.primary),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: _category,
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    decoration: InputDecoration(
                      labelText: 'קטגוריה',
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    items: [
                      for (var category in categoryNames.keys)
                        DropdownMenuItem(
                          value: category,
                          child: Text(categoryNames[category]!),
                        ),
                    ],
                    onChanged: (value) {
                      _category = value!;
                    },
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      jewishDateFormat
                          .format(JewishDate.fromDateTime(_pickedDate)),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    Text(
                      dateFormat.format(_pickedDate),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  iconSize: 30,
                  icon: Stack(
                    alignment: Alignment.lerp(
                            Alignment.center, Alignment.bottomCenter, 0.5) ??
                        Alignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        'א',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  onPressed: _chooseDateJewish,
                ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  iconSize: 30,
                  icon: Stack(
                    alignment: Alignment.lerp(
                            Alignment.center, Alignment.bottomCenter, 0.65) ??
                        Alignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        '1',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                  onPressed: _chooseDateGregorian,
                ),
              ],
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      _submit();
                    },
                    child: Text('עדכן'),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('ביטול'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
