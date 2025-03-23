import 'package:flutter/material.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:zman_limud_demo/util/category.dart';
import 'package:zman_limud_demo/util/general_util.dart';

class LearnTime {
  late final String id;
  late final String title;
  late final TimeOfDay startTime;
  late final TimeOfDay endTime;
  late final DateTime date;
  late final Category category;

  LearnTime({
    String? id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.category,
  }) : id = id ?? uuid.v4();

  LearnTime.fromMap(Map<String, dynamic> map) {
    // Parse start time
    final startTimeParts = (map['start_time'] as String).split(':');
    startTime = TimeOfDay(
      hour: int.parse(startTimeParts[0]),
      minute: int.parse(startTimeParts[1]),
    );

    // Parse end time
    final endTimeParts = (map['end_time'] as String).split(':');
    endTime = TimeOfDay(
      hour: int.parse(endTimeParts[0]),
      minute: int.parse(endTimeParts[1]),
    );

    // Parse category
    category = Category.values.firstWhere(
      (e) => e.toString() == map['category'],
      orElse: () => Category.other, // default category if not found
    );

    title = map['title'];
    date = DateTime.parse(map['date']);
    id = map['id'];
  }

  String get jewishFormattedDate =>
      jewishDateFormat.format(JewishDate.fromDateTime(date));

  String get formattedDate => dateFormat.format(date);

  double get hours {
    int minutesStart = startTime.hour * 60 + startTime.minute;
    int minutesEnd = endTime.hour * 60 + endTime.minute;
    if (minutesStart > minutesEnd) {
      minutesEnd += 24 * 60;
    }
    return (minutesEnd - minutesStart) / 60;
  }

  String get formattedHours => hours == 0
      ? 'ביטול תורה מוחלט'
      : hours < 1
          ? '${doublesFormat.format((hours * 60) % 60)} דקות'
          : hours.toInt() == hours
              ? '${doublesFormat.format(hours.floor())} שעות'
              : '${doublesFormat.format(hours.floor())} שעות ו${doublesFormat.format((hours * 60) % 60)} דקות';

  Map<String, dynamic> get map => {
        'id': id,
        'title': title,
        'start_time': '${startTime.hour}:${startTime.minute}',
        'end_time': '${endTime.hour}:${endTime.minute}',
        'date': date.toIso8601String(),
        'category': category.toString(),
      };

  @override
  bool operator ==(Object other) {
    if (other is LearnTime) {
      return id == other.id;
    }
    return super == other;
  }

  @override
  int get hashCode => id.hashCode;
}
