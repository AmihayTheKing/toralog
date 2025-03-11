import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:kosher_dart/kosher_dart.dart';

enum DateType { jewish, gregorian }

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

extension DateTimeExtenson on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension JewishDateExtension on JewishDate {
  String getFormattedDateForChart() {
    return '${jewishDateFormat.format(this).substring(0, jewishDateFormat.format(this).indexOf(' ') + 3)}${getJewishMonth() != 5 ? '\'' : ''}';
  }
}
