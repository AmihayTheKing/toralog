import 'dart:io';
import 'package:cupertino_hebrew_date_picker/cupertino_hebrew_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:material_hebrew_date_picker/material_hebrew_date_picker.dart';
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
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TimeOfDay _pickedStartTime = TimeOfDay.now()
      .copyWith(hour: TimeOfDay.now().hour > 0 ? TimeOfDay.now().hour - 1 : 23);
  TimeOfDay _pickedEndTime = TimeOfDay.now();
  DateTime _pickedDate = DateTime.now();
  Category? _pickedCategory;
  late double hourPickRowFontSize;

  void _submit() async {
    bool ifReturn = false;

    if (!(_formKey.currentState!).validate()) {
      return;
    }
    if (_titleController.text.isEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('אתה בטוח שאתה לא רוצה להוסיף כותרת?'),
          actions: [
            TextButton(
              onPressed: () {
                ifReturn = true;
                Navigator.pop(context);
              },
              child: Text('בטל'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
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
            category: _pickedCategory!,
          ),
        );
    Navigator.pop(context);
  }

  void _chooseStartTime() async {
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => SizedBox(
          height: getAdaptiveHeight(context, 200),
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
          height: getAdaptiveHeight(context, 200),
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
      (
        await showCupertinoModalPopup(
          context: context,
          builder: (context) => SizedBox(
            height: getAdaptiveHeight(context, 200),
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
        ),
      );
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
          height: getAdaptiveHeight(context, 200),
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
      onDateChange: (date) {
        setState(() => _pickedDate = date);
      },
      theme: getHebrewDatePickerTheme(context),
    );
  }

  Widget _createChoosingTitleRow() {
    return TextFormField(
      controller: _titleController,
      maxLength: 50,
      decoration: InputDecoration(
          labelText: 'כותרת',
          labelStyle: TextStyle()
              .copyWith(color: Theme.of(context).colorScheme.primary)),
    );
  }

  Widget _createChoosingTimeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _chooseEndTime,
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.zero,
            ),
          ),
          child: Text(
            _pickedEndTime.format(context),
            style: TextStyle().copyWith(fontSize: hourPickRowFontSize),
          ),
        ),
        Text(
          'עד שעה:',
          style: TextStyle(
              fontSize: hourPickRowFontSize,
              color: Theme.of(context).colorScheme.primary),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(width: getAdaptiveWidth(context, 6)),
        Text(
          '\u2014', // -
          style: TextStyle(
            fontSize: hourPickRowFontSize,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(width: getAdaptiveWidth(context, 6)),
        TextButton(
          onPressed: _chooseStartTime,
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.zero,
            ),
          ),
          child: Text(
            _pickedStartTime.format(context),
            style: TextStyle().copyWith(fontSize: hourPickRowFontSize),
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
    );
  }

  Widget _createChoosingCategoryAndDateRow() {
    return Row(
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
              _pickedCategory = value;
            },
          ),
        ),
        SizedBox(width: getAdaptiveWidth(context, 8)),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              jewishDateFormat.format(JewishDate.fromDateTime(_pickedDate)),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            Text(
              dateFormat.format(_pickedDate),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
        IconButton(
          padding: EdgeInsets.zero,
          iconSize: getAdaptiveHeight(context, 30),
          icon: Stack(
            children: [
              Positioned(
                child: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Positioned(
                top: getAdaptiveHeight(context, 6),
                left: getAdaptiveWidth(context, 10),
                child: Text(
                  'א',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          onPressed: _chooseDateJewish,
        ),
        IconButton(
          padding: EdgeInsets.zero,
          iconSize: getAdaptiveHeight(context, 30),
          icon: Stack(
            children: [
              Positioned(
                child: Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Positioned(
                top: getAdaptiveHeight(context, 7),
                left: getAdaptiveWidth(context, 11),
                child: Text(
                  '1',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: getAdaptiveHeight(context, 13.5),
                  ),
                ),
              ),
            ],
          ),
          onPressed: _chooseDateGregorian,
        ),
      ],
    );
  }

  Widget _createSubmitButtonsRow() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              _submit();
            },
            child: Text('הוסף'),
          ),
          SizedBox(width: getAdaptiveWidth(context, 8)),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('ביטול'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    hourPickRowFontSize = getAdaptiveHeight(context, 20);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(getAdaptiveHeight(context, 16)),
        child: Column(
          children: [
            _createChoosingTitleRow(),
            Flexible(child: _createChoosingTimeRow()),
            SizedBox(height: getAdaptiveHeight(context, 8)),
            _createChoosingCategoryAndDateRow(),
            SizedBox(height: getAdaptiveHeight(context, 8)),
            _createSubmitButtonsRow(),
          ],
        ),
      ),
    );
  }
}
