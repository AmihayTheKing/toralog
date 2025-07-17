import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:zman_limud_demo/hebrewDatePicker/cupertino_hebrew_date_picker.dart';
import 'package:zman_limud_demo/hebrewDatePicker/material_hebrew_date_picker.dart';
import 'package:zman_limud_demo/hebrewDatePicker/hebrew_date_picker_theme.dart';
import 'package:zman_limud_demo/util/category.dart';
import 'package:zman_limud_demo/models/learn_time.dart';
import 'package:zman_limud_demo/util/general_util.dart';
import '../providers/learn_times_provider.dart';

class AddMenu extends ConsumerStatefulWidget {
  const AddMenu({super.key});

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends ConsumerState<AddMenu> {
  final TextEditingController _titleController = TextEditingController();
  TimeOfDay _pickedStartTime = TimeOfDay(
      hour: TimeOfDay.now().hour > 0 ? TimeOfDay.now().hour - 1 : 23,
      minute: TimeOfDay.now().minute);
  TimeOfDay _pickedEndTime = TimeOfDay.now();
  DateTime _pickedDate = DateTime.now();
  Category? _category;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submit() async {
    bool ifReturn = false;

    if (!(_formKey.currentState!).validate()) {
      return;
    }
    if (_titleController.text.isEmpty) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text('אתה בטוח שאתה לא רוצה להוסיף כותרת?'),
          actions: [
            TextButton(
              onPressed: () {
                ifReturn = true;
                Navigator.pop(ctx);
              },
              child: Text('בטל'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('אישור'),
            ),
          ],
        ),
      );
    }
    if (ifReturn) {
      return;
    }

    ref.read(learnTimesProvider.notifier).addLearnTime(
          LearnTime(
            title: _titleController.text,
            startTime: _pickedStartTime,
            endTime: _pickedEndTime,
            date: _pickedDate,
            category: _category!,
          ),
        );
    Navigator.pop(context);
  }

  void _chooseStartTime() async {
    _pickedStartTime = await showTimePicker(
          context: context,
          initialTime: _pickedStartTime,
        ) ??
        _pickedStartTime;
    setState(() {});
  }

  void _chooseEndTime() async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: DateTime.now(),
            use24hFormat: true,
            onDateTimeChanged: (DateTime value) {
              setState(
                () => _pickedEndTime = TimeOfDay.fromDateTime(value),
              );
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
      (await showCupertinoModalPopup(
        context: context,
        builder: (context) => SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _pickedDate,
            minimumDate: DateTime(DateTime.now().year - 1),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime value) {
              setState(
                () => _pickedDate = value,
              );
            },
          ),
        ),
      ));
    } else {
      _pickedDate = (await showDatePicker(
            context: context,
            initialDate: _pickedDate,
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime.now(),
          )) ??
          DateTime.now();
      setState(() {});
    }
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
    }
    await showMaterialHebrewDatePicker(
      context: context,
      initialDate: _pickedDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 30)),
      hebrewFormat: true,
      onConfirmDate: (date) {
        setState(() => _pickedDate = date);
      },
      onDateChange: (DateTime value) {},
      theme: HebrewDatePickerTheme(
        primaryColor: Theme.of(context).colorScheme.primary,
        onPrimaryColor: Theme.of(context).colorScheme.onPrimary,
        surfaceColor: Theme.of(context).colorScheme.surface,
        onSurfaceColor: Theme.of(context).colorScheme.onSurface,
        disabledColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
        selectedColor: Theme.of(context).colorScheme.primary,
        todayColor: Theme.of(context).colorScheme.primary,
        headerTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.primary,
        ),
        weekdayTextStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double hourPickRowFontSize = 20;

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              maxLength: 50,
              decoration: InputDecoration(
                  labelText: 'כותרת',
                  labelStyle: TextStyle()
                      .copyWith(color: Theme.of(context).colorScheme.primary)),
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
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    decoration: InputDecoration(
                      labelText: 'קטגוריה',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'נא לבחור קטגוריה';
                      }
                      return null;
                    },
                    items: [
                      for (var category in categoryNames.keys)
                        DropdownMenuItem(
                          value: category,
                          child: Text(categoryNames[category]!),
                        ),
                    ],
                    onChanged: (value) {
                      _category = value;
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
                    child: Text('הוסף'),
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
