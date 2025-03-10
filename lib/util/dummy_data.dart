import 'package:flutter/material.dart';
import 'package:zman_limud_demo/models/learn_time.dart';
import 'package:zman_limud_demo/util/category.dart';

List<LearnTime> dummyLearnTimes = [
  LearnTime(
      title: 'תנ"ך',
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(
          hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute + 3),
      date: DateTime.now(),
      category: Category.tanach),
  LearnTime(
      title: 'משנה',
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(
          hour: TimeOfDay.now().hour + 2, minute: TimeOfDay.now().minute),
      date: DateTime.now(),
      category: Category.mishna),
  LearnTime(
      title: 'גמרא',
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(
          hour: TimeOfDay.now().hour + 3, minute: TimeOfDay.now().minute),
      date: DateTime.now(),
      category: Category.gemara),
  LearnTime(
      title: 'הלכה',
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(
          hour: TimeOfDay.now().hour + 4, minute: TimeOfDay.now().minute),
      date: DateTime.now(),
      category: Category.halacha),
  LearnTime(
      title: 'אמונה',
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(
          hour: TimeOfDay.now().hour + 5, minute: TimeOfDay.now().minute),
      date: DateTime.now(),
      category: Category.emuna),
  LearnTime(
      title: 'חסידות',
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(
          hour: TimeOfDay.now().hour + 6, minute: TimeOfDay.now().minute),
      date: DateTime.now(),
      category: Category.chassidut)
];
