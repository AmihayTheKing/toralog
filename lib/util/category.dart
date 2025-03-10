// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

enum Category { tanach, mishna, gemara, halacha, emuna, chassidut, other }

Map<Category, String> categoryNames = {
  Category.tanach: 'תנ"ך',
  Category.mishna: 'משנה',
  Category.gemara: 'גמרא',
  Category.halacha: 'הלכה',
  Category.emuna: 'אמונה',
  Category.chassidut: 'חסידות',
  Category.other: 'אחר',
};

Map<Category, Color> categoryColors = {
  Category.tanach: Color(0xFF014E60),
  Category.mishna: Color.fromARGB(255, 90, 153, 184),
  Category.gemara: Color(0xFFCCB478),
  Category.halacha: Color.fromARGB(255, 190, 60, 90),
  Category.emuna: Color(0xFF7F85A9),
  Category.chassidut: Color(0xFF97B285),
  Category.other: Color(0xFF594175),
};

Map<Category, String> categoryChartLabels = {
  Category.tanach: 'תנ\'',
  Category.mishna: 'מש\'',
  Category.gemara: 'גמ\'',
  Category.halacha: 'הל\'',
  Category.emuna: 'אמ\'',
  Category.chassidut: 'חס\'',
  Category.other: 'אח\'',
};
