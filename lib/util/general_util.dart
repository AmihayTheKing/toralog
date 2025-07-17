import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:zman_limud_demo/hebrewDatePicker/hebrew_date_picker_theme.dart';

final Uuid uuid = Uuid();
final DateFormat dateFormatWithHour = DateFormat.yMd().add_Hm();
final DateFormat dateFormat = DateFormat.yMd();
final DateFormat dateFormatForChart = DateFormat.Md();
final TimeOfDayFormat timeFormat = TimeOfDayFormat.HH_colon_mm;
final NumberFormat doublesFormat = NumberFormat('#.##');
final HebrewDateFormatter jewishDateFormat = HebrewDateFormatter()
  ..hebrewFormat = true
  ..useFinalFormLetters = true;
final DateFormat onlyHourDateFormat = DateFormat.Hm();

class GeneralUtil {
  static HebrewDatePickerTheme getHebrewDatePickerTheme(BuildContext context) {
    return HebrewDatePickerTheme(
      primaryColor: Theme.of(context).colorScheme.primary,
      onPrimaryColor: Theme.of(context).colorScheme.onPrimary,
      surfaceColor: Theme.of(context).colorScheme.surface,
      onSurfaceColor: Theme.of(context).colorScheme.onSurface,
      disabledColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
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
    );
  }
}

extension DateTimeExtenson on DateTime {
  DateTime get onlyDate {
    return copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension JewishDateExtension on JewishDate {
  String getFormattedDateForChart() {
    return '${jewishDateFormat.format(this).substring(0, jewishDateFormat.format(this).indexOf(' ') + 3)}${getJewishMonth() != 5 ? '\'' : ''}';
  }
}
